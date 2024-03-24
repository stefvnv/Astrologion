import UIKit
import Foundation
import CoreGraphics

class NatalChartView: UIView {
    var viewModel: NatalChartViewModel? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeView()
    }
    
    func redrawChart() {
        setNeedsDisplay()  // This triggers the draw(_:) method
    }

    
    private func initializeView() {
        
        // Initialize tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)

        // Set background color to navy
        backgroundColor = ChartColor.navy.uiColor
    }

    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tapLocation = gestureRecognizer.location(in: self)
        viewModel?.handleTap(location: tapLocation, inViewBounds: bounds)
    }
    
    var houseInnerRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * 0.8 * 0.7 // innerZodiacRadius * houseInnerRadius (last 2 numbers)
    }
    
    
    
    fileprivate func defineChartSize(_ rect: CGRect, _ context: CGContext) {
        let scaleFactor: CGFloat = 0.85 // scales chart size
        
        context.saveGState() // Save the current graphics state
        context.translateBy(x: rect.midX * (1 - scaleFactor), y: rect.midY * (1 - scaleFactor))
        context.scaleBy(x: scaleFactor, y: scaleFactor)
    }
    
    /// Main draw method which calls other methods for drawing all elements onto the view
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(), let viewModel = viewModel else { return }
        
        // Define chart size
        defineChartSize(rect, context)
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let ascendant = viewModel.ascendant() // asc from VM
        
        let outerZodiacRadius = min(bounds.size.width, bounds.size.height) / 2
        let innerZodiacRadius = outerZodiacRadius * 0.8
        
        let houseOuterRadius = innerZodiacRadius * 0.8
        let houseInnerRadius = innerZodiacRadius * 0.7
        
        ///
        // Draw zodiac portion of chart
        // Draw the outer zodiac circle
        drawZodiacOuterCircle(context, center, outerZodiacRadius)

        // Fill the area between the outer and inner zodiac circles with gold
        context.setFillColor(ChartColor.gold.uiColor.cgColor)
        context.addArc(center: center, radius: outerZodiacRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        context.addArc(center: center, radius: innerZodiacRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        context.fillPath()

        // Draw the inner zodiac circle
        drawZodiacInnerCircle(context, center, innerZodiacRadius)

        ///
        drawMidpointLines(context, innerZodiacRadius, outerZodiacRadius, ascendant)
        drawZodiacSymbols(outerZodiacRadius, innerZodiacRadius, center)
        
        // Draw house portion of chart
        drawHouseOuterCircle(context, center, houseOuterRadius)
        drawHouseInnerCircle(context, center, houseInnerRadius)
        drawHouses(rect, context, houseInnerRadius, houseOuterRadius, innerZodiacRadius, center)
        
        // Draw planets onto chart
        drawPlanets(rect, context, outerZodiacRadius, innerZodiacRadius)
        
        // Draw aspects onto chart
        drawAspects(context: context, houseInnerRadius: houseInnerRadius)
        
        //
        drawScaleMarkings(context, center, innerZodiacRadius, outerZodiacRadius, viewModel.ascendant())

        // Draw ASC/DSC and MC/IC arrows (pointers)
        drawAscDscArrow(context, center, outerZodiacRadius)
        drawMcIcArrow(context, center, outerZodiacRadius)
        
        context.restoreGState() // restore graphics
    }
    
    
    ///
    fileprivate func drawMcIcArrow(_ context: CGContext, _ center: CGPoint, _ outerRadius: CGFloat) {
        guard let viewModel = viewModel else { return }

        let houseCusps = viewModel.houseCusps()
        if houseCusps.count < 4 { return }

        let fontSize: CGFloat = outerRadius / 20 // Text size
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: ChartColor.gold.uiColor
        ]

        // Correcting the angles for MC (10th cusp) and IC (4th cusp)
        let mcAngleRadians = (360 - houseCusps[3] + viewModel.ascendant()).truncatingRemainder(dividingBy: 360).degreesToRadians
        let icAngleRadians = (360 - houseCusps[9] + viewModel.ascendant()).truncatingRemainder(dividingBy: 360).degreesToRadians

        let startRadius = outerRadius + 5 // Start just beyond the outer circle
        let extendedRadius = startRadius + 20 // Extend 20 points beyond the start points

        // Calculate start and end points for MC and IC lines
        let mcStartPoint = CGPoint(x: center.x + startRadius * cos(mcAngleRadians), y: center.y + startRadius * sin(mcAngleRadians))
        let mcEndPoint = CGPoint(x: center.x + extendedRadius * cos(mcAngleRadians), y: center.y + extendedRadius * sin(mcAngleRadians))
        let icStartPoint = CGPoint(x: center.x + startRadius * cos(icAngleRadians), y: center.y + startRadius * sin(icAngleRadians))
        let icEndPoint = CGPoint(x: center.x + extendedRadius * cos(icAngleRadians), y: center.y + extendedRadius * sin(icAngleRadians))

        // Draw MC line with arrow
        drawLineWithArrow(context: context, start: mcStartPoint, end: mcEndPoint, arrowSize: 10)

        // Draw IC line
        context.setStrokeColor(ChartColor.gold.uiColor.cgColor)
        context.setLineWidth(2)
        context.beginPath()
        context.move(to: icStartPoint)
        context.addLine(to: icEndPoint)
        context.strokePath()

        // Draw "MC" text above the MC arrow
        let mcText = NSAttributedString(string: "MC", attributes: attributes)
        let mcTextSize = mcText.size()
        let mcTextPoint = CGPoint(x: mcEndPoint.x - mcTextSize.width / 2, y: mcEndPoint.y - mcTextSize.height - 10)
        mcText.draw(at: mcTextPoint)

        // Draw "IC" text near the IC line
        let icText = NSAttributedString(string: "IC", attributes: attributes)
        let icTextSize = icText.size()
        let icTextPoint = CGPoint(x: icEndPoint.x - icTextSize.width / 2, y: icEndPoint.y + 10)
        icText.draw(at: icTextPoint)
    }



    ///
    fileprivate func drawAscDscArrow(_ context: CGContext, _ center: CGPoint, _ outerRadius: CGFloat) {
        let fontSize: CGFloat = outerRadius / 20  // text size

        // Configuration for the text attributes with scalable font size
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: ChartColor.gold.uiColor
        ]

        // Ascendant (9 o'clock) and Descendant (3 o'clock) positions
        let ascendantAngle = 180.degreesToRadians // 9 o'clock position in radians
        let descendantAngle = 0.degreesToRadians // 3 o'clock position in radians

        // Define the start points just outside the outer circle
        let startRadius = outerRadius + 5 // Start 5 points beyond the outer circle for a slight overlap

        // Ascendant line starting point
        let ascendantStartPoint = CGPoint(
            x: center.x + startRadius * cos(ascendantAngle),
            y: center.y + startRadius * sin(ascendantAngle)
        )
        
        // Descendant line starting point
        let descendantStartPoint = CGPoint(
            x: center.x + startRadius * cos(descendantAngle),
            y: center.y + startRadius * sin(descendantAngle)
        )
        
        // Extend beyond the start points for the ascendant and descendant lines
        let extendedRadius = startRadius + 20 // Extend 20 points beyond the start points

        // Ascendant line ending point
        let ascendantEndPoint = CGPoint(
            x: center.x + extendedRadius * cos(ascendantAngle),
            y: center.y + extendedRadius * sin(ascendantAngle)
        )
        
        // Descendant line ending point
        let descendantEndPoint = CGPoint(
            x: center.x + extendedRadius * cos(descendantAngle),
            y: center.y + extendedRadius * sin(descendantAngle)
        )
        
        // Draw ascendant line with arrow
        drawLineWithArrow(context: context, start: ascendantStartPoint, end: ascendantEndPoint, arrowSize: 10)
        
        // Draw descendant line
        context.setStrokeColor(ChartColor.gold.uiColor.cgColor)
        context.setLineWidth(2)
        context.beginPath()
        context.move(to: descendantStartPoint)
        context.addLine(to: descendantEndPoint)
        context.strokePath()

        // Draw "ASC" text above the ascendant arrow using the symbol from AngularHouse enum
        let ascText = NSAttributedString(string: AngularHouse.ascendant.symbol, attributes: attributes)
        let ascTextSize = ascText.size()
        let ascTextPoint = CGPoint(
            x: ascendantEndPoint.x - ascTextSize.width / 2,
            y: ascendantEndPoint.y - ascTextSize.height - 10 // Adjust the y offset as needed
        )
        ascText.draw(at: ascTextPoint)

        // Draw "DSC" text above the descendant line using the symbol from AngularHouse enum
        let dscText = NSAttributedString(string: AngularHouse.descendant.symbol, attributes: attributes)
        let dscTextSize = dscText.size()
        let dscTextPoint = CGPoint(
            x: descendantEndPoint.x - dscTextSize.width / 2,
            y: descendantEndPoint.y - dscTextSize.height - 10 // Adjust the y offset as needed
        )
        dscText.draw(at: dscTextPoint)
    }


    /// Draws a line with an arrow at the end
    fileprivate func drawLineWithArrow(context: CGContext, start: CGPoint, end: CGPoint, arrowSize: CGFloat) {
        let goldColor = ChartColor.gold.uiColor.cgColor
        context.setStrokeColor(goldColor)
        context.setFillColor(goldColor)  // Setting fill color to gold for the arrowhead
        context.setLineWidth(2)
        
        // Draw the line
        context.beginPath()
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()
        
        // Calculate the angle of the line
        let angle = atan2(end.y - start.y, end.x - start.x)
        
        // Draw the arrowhead at the end of the line
        context.beginPath()
        context.move(to: end)
        context.addLine(to: CGPoint(
            x: end.x - arrowSize * cos(angle + CGFloat.pi / 6),
            y: end.y - arrowSize * sin(angle + CGFloat.pi / 6))
        )
        context.addLine(to: CGPoint(
            x: end.x - arrowSize * cos(angle - CGFloat.pi / 6),
            y: end.y - arrowSize * sin(angle - CGFloat.pi / 6))
        )
        context.closePath()
        context.fillPath()
    }
    
    
    ///
    fileprivate func drawScaleMarkings(_ context: CGContext, _ center: CGPoint, _ innerRadius: CGFloat, _ outerRadius: CGFloat, _ ascendantOffset: Double) {
        let regularScaleLength: CGFloat = 16 // The length of the regular scale lines
        let longScaleLength: CGFloat = 8 // The length of the longer scale lines for 3rd, 5th, and 7th markings
        let marksPerSign = 7 // number of lines between signs
        let totalSigns = 12 // Total number of zodiac signs
        
        context.setStrokeColor(ChartColor.navy.uiColor.cgColor)
        context.setLineWidth(1) // width
        
        for signIndex in 0..<totalSigns {
            for markIndex in 0..<(marksPerSign + 1) {
                let angleIncrement = 30.0 / Double(marksPerSign + 1)
                let angle = (Double(signIndex) * 30.0 + Double(markIndex) * angleIncrement + ascendantOffset).truncatingRemainder(dividingBy: 360.0).degreesToRadians
                
                let scaleLength = (markIndex == 3 || markIndex == 5 || markIndex == 7) ? longScaleLength : regularScaleLength
                let start = CGPoint(x: center.x + innerRadius * cos(angle), y: center.y + innerRadius * sin(angle))
                let end = CGPoint(x: center.x + (innerRadius + scaleLength) * cos(angle), y: center.y + (innerRadius + scaleLength) * sin(angle))
                
                context.beginPath()
                context.move(to: start)
                context.addLine(to: end)
                context.strokePath()
            }
        }
    }
    
    
    ///
    private func drawAspects(context: CGContext, houseInnerRadius: CGFloat) {
        guard let viewModel = viewModel else { return }
        let aspects = viewModel.aspects
        let planetPositions = viewModel.getPlanetPositions(in: bounds)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        for aspectData in aspects {
            guard let startPlanetPosition = planetPositions.first(where: { $0.planet == aspectData.planet1 })?.position,
                  let endPlanetPosition = planetPositions.first(where: { $0.planet == aspectData.planet2 })?.position else {
                continue
            }

            // Calculate the intersection points for both planets
            let startIntersection = intersectionPointOnCircle(circleCenter: center, circleRadius: houseInnerRadius, externalPoint: startPlanetPosition)
            let endIntersection = intersectionPointOnCircle(circleCenter: center, circleRadius: houseInnerRadius, externalPoint: endPlanetPosition)

            // Draw the aspect line between the two intersection points
            context.setStrokeColor(aspectData.aspect.uiColor.cgColor)
            context.setLineWidth(2)
            context.beginPath()
            context.move(to: startIntersection)
            context.addLine(to: endIntersection)
            context.strokePath()
        }
    }

    
    
    ///
    private func intersectionPointOnCircle(circleCenter: CGPoint, circleRadius: CGFloat, externalPoint: CGPoint) -> CGPoint {
        let dx = externalPoint.x - circleCenter.x
        let dy = externalPoint.y - circleCenter.y
        let scale = circleRadius / sqrt(dx * dx + dy * dy)
        return CGPoint(x: circleCenter.x + scale * dx, y: circleCenter.y + scale * dy)
    }
    
    
    ///
    fileprivate func drawHouseNumbers(_ houseInnerRadius: CGFloat, _ houseOuterRadius: CGFloat, _ center: CGPoint, _ midAngle: Double, _ index: Int, _ font: UIFont, _ paragraphStyle: NSMutableParagraphStyle, _ context: CGContext) {

        let radiusForText = (houseInnerRadius + houseOuterRadius) / 2
        let textPosition = CGPoint(x: center.x + radiusForText * cos(midAngle), y: center.y + radiusForText * sin(midAngle))
        
        if let houseEnum = House(rawValue: index + 1) {
            let houseNumber = houseEnum.romanNumeral
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: ChartColor.gold.uiColor,
                .paragraphStyle: paragraphStyle
            ]
            let houseNumberSize = houseNumber.size(withAttributes: textAttributes) // calculate size of house number
            context.saveGState() // save graphics state before making transformations
            context.translateBy(x: textPosition.x, y: textPosition.y) // translate context to text position
            context.rotate(by: CGFloat(midAngle) - .pi / 2) // rotate context to align text correctly
            
            // draw house number centered at calculated point
            houseNumber.draw(in: CGRect(x: -houseNumberSize.width / 2, y: -houseNumberSize.height / 2, width: houseNumberSize.width, height: houseNumberSize.height), withAttributes: textAttributes)
            context.restoreGState() // restore graphics state after drawing text
        }
    }
    
    
    ///
    fileprivate func drawHouses(_ rect: CGRect, _ context: CGContext, _ houseInnerRadius: CGFloat, _ houseOuterRadius: CGFloat, _ innerZodiacRadius: CGFloat, _ center: CGPoint) {
        guard let houseCusps = viewModel?.houseCusps(), houseCusps.count == 12, let ascendant = viewModel?.ascendant() else { return }
        
        let font = UIFont.systemFont(ofSize: 12)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let offsetToNineOClock = 180.0 - ascendant // 9 oclock
        
        for (index, cusp) in houseCusps.enumerated() {
            var adjustedCuspAngle = cusp + offsetToNineOClock
            adjustedCuspAngle = adjustedCuspAngle.truncatingRemainder(dividingBy: 360)
            let angle = (360 - adjustedCuspAngle).degreesToRadians
            
            let start = CGPoint(x: center.x + houseInnerRadius * cos(angle), y: center.y + houseInnerRadius * sin(angle))
            let end = CGPoint(x: center.x + innerZodiacRadius * cos(angle), y: center.y + innerZodiacRadius * sin(angle))
            context.setStrokeColor(ChartColor.gold.uiColor.cgColor)
            context.beginPath()
            context.move(to: start)
            context.addLine(to: end)
            context.strokePath()
            
            let nextCuspIndex = (index + 1) % houseCusps.count
            var adjustedNextCuspAngle = houseCusps[nextCuspIndex] + offsetToNineOClock
            adjustedNextCuspAngle = adjustedNextCuspAngle.truncatingRemainder(dividingBy: 360)
            let nextAngle = (360 - adjustedNextCuspAngle).degreesToRadians
            
            var midAngle = (angle + nextAngle) / 2
            if abs(angle - nextAngle) > .pi {
                midAngle = (midAngle + .pi).truncatingRemainder(dividingBy: 2 * .pi)
            }
            drawHouseNumbers(houseInnerRadius, houseOuterRadius, center, midAngle, index, font, paragraphStyle, context)
        }
    }
    
    
    ///
    fileprivate func drawHouseOuterCircle(_ context: CGContext, _ center: CGPoint, _ houseOuterRadius: CGFloat) {
        context.addArc(center: center, radius: houseOuterRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        context.setStrokeColor(ChartColor.gold.uiColor.cgColor)
        context.setLineWidth(2)
        context.strokePath()
    }
    
    
    ///
    fileprivate func drawHouseInnerCircle(_ context: CGContext, _ center: CGPoint, _ houseInnerRadius: CGFloat) {
        context.addArc(center: center, radius: houseInnerRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        context.setStrokeColor(ChartColor.gold.uiColor.cgColor)
        context.setLineWidth(2)
        context.strokePath()
    }
    
    
    /// Draws zodiac symbols along the chart
    fileprivate func drawZodiacSymbols(_ outerRadius: CGFloat, _ innerRadius: CGFloat, _ center: CGPoint) {
        guard let ascendant = viewModel?.ascendant() else { return }
        let ascendantOffset = 180.0 - ascendant
        let signRadius = (outerRadius + innerRadius) / 2
        let font = UIFont.systemFont(ofSize: outerRadius / 7)
        
        for i in 0..<Zodiac.allCases.count {
            let sign = Zodiac.allCases[i]
            let adjustedAngle = (Double(sign.order) * 30.0 + 15.0 + ascendantOffset).truncatingRemainder(dividingBy: 360.0)
            let radians = (360.0 - adjustedAngle).degreesToRadians
            
            let textAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: ChartColor.navy.uiColor]
            let attributedString = NSAttributedString(string: sign.symbol, attributes: textAttributes)
            let textSize = attributedString.size()
            
            let x = center.x + signRadius * cos(radians) - textSize.width / 2
            let y = center.y + signRadius * sin(radians) - textSize.height / 2
            
            attributedString.draw(at: CGPoint(x: x, y: y))
            attributedString.draw(at: CGPoint(x: x, y: y))
        }
        
    }
    
    
    ///
    fileprivate func drawZodiacOuterCircle(_ context: CGContext, _ center: CGPoint, _ outerRadius: CGFloat) {
        context.addArc(center: center, radius: outerRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.setLineWidth(5)
        context.strokePath()
    }
    
    
    ///
    fileprivate func drawZodiacInnerCircle(_ context: CGContext, _ center: CGPoint, _ innerRadius: CGFloat) {
        context.addArc(center: center, radius: innerRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(3)
        context.strokePath()
    }
    
    
    ///
    fileprivate func drawMidpointLines(_ context: CGContext, _ innerRadius: CGFloat, _ outerRadius: CGFloat, _ ascendant: Double) {
        let ascendantOffset = 180.0 - ascendant
        context.setStrokeColor(UIColor.gray.cgColor)
        context.setLineWidth(1)
        
        for i in 0..<12 {
            
            let midpoint = Double(i) * 30.0 + ascendantOffset
            
            let adjustedMidpoint = (midpoint + 360.0).truncatingRemainder(dividingBy: 360.0)
            let radians = (360.0 - adjustedMidpoint).degreesToRadians
            
            let start = CGPoint(x: center.x + innerRadius * cos(radians), y: center.y + innerRadius * sin(radians))
            let end = CGPoint(x: center.x + outerRadius * cos(radians), y: center.y + outerRadius * sin(radians))
            
            // Draw the line
            context.move(to: start)
            context.addLine(to: end)
            context.strokePath()
        }
    }
    
    
    ///
    fileprivate func drawPlanets(_ rect: CGRect, _ context: CGContext, _ outerZodiacRadius: CGFloat, _ innerZodiacRadius: CGFloat) {
        guard let viewModel = viewModel else { return }
        let ascendant = viewModel.ascendant()
        let font = UIFont.systemFont(ofSize: outerZodiacRadius / 10) // size
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let planetPositions = viewModel.getPlanetPositions(in: rect)
        
        var adjustments = [Int: CGFloat]()
        
        // checking planets proximity to one another
        for i in 0..<planetPositions.count {
            for j in i+1..<planetPositions.count {
                let planet1 = planetPositions[i]
                let planet2 = planetPositions[j]
                let longitudeDifference = abs(planet1.longitude - planet2.longitude)
                
                if longitudeDifference < 5 || longitudeDifference > 355 {
                    let adjustmentIndex = (planet1.longitude < planet2.longitude) ? i : j
                    
                    if longitudeDifference <= 2.5 || (longitudeDifference >= 357.5 && longitudeDifference <= 360) {
                        adjustments[adjustmentIndex] = -5.0
                    } else if longitudeDifference > 2.5 && longitudeDifference < 5 {
                        adjustments[adjustmentIndex] = -3.0
                    }
                }
            }
        }
        
        // Draw the planets and their lines
        for (index, planetPosition) in planetPositions.enumerated() {
            let planet = planetPosition.planet
            let originalPosition = planetPosition.position
            let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: planet.color]
            
            var symbolPosition = originalPosition
            if let adjustment = adjustments[index] {
                let adjustedLongitude = planetPosition.longitude + adjustment
                symbolPosition = viewModel.calculatePositionForPlanet(planet, at: adjustedLongitude, usingAscendant: ascendant, in: rect)
            }
            let planetSymbol = NSAttributedString(string: planet.symbol ?? "", attributes: attributes)
            let textSize = planetSymbol.size()
            planetSymbol.draw(at: CGPoint(x: symbolPosition.x - textSize.width / 2, y: symbolPosition.y - textSize.height / 2))
            
            let lineEnd = intersectionPointOnCircle(circleCenter: center, circleRadius: innerZodiacRadius, externalPoint: originalPosition)
            
            let lineStartX = originalPosition.x + (lineEnd.x - originalPosition.x) * 0.5
            let lineStartY = originalPosition.y + (lineEnd.y - originalPosition.y) * 0.5
            let lineStart = CGPoint(x: lineStartX, y: lineStartY)
            
            context.setStrokeColor(planet.color.cgColor)
            context.setLineWidth(2)
            context.beginPath()
            context.move(to: lineStart)
            context.addLine(to: lineEnd)
            context.strokePath()
        }
    }
}


extension CGFloat {
    var degreesToRadians: CGFloat {
        return self * .pi / 180
    }
}

extension Double {
    var degreesToRadians: Double {
        return self * .pi / 180.0
    }
}
