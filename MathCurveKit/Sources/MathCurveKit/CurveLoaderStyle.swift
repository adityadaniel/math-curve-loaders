public enum CurveLoaderStyle: String, CaseIterable, Hashable {
  case originalThinking
  case thinkingFive
  case thinkingNine
  case roseOrbit
  case rose
  case roseTwo
  case roseThree
  case roseFour
  case lissajousDrift
  case lemniscateBloom
  case hypotrochoidLoop
  case threePetalSpiral
  case fourPetalSpiral
  case fivePetalSpiral
  case sixPetalSpiral
  case butterflyPhase
  case cardioidGlow
  case cardioidHeart
  case heartWave
  case spiralSearch
  case fourierFlow

  internal var specID: String {
    switch self {
    case .originalThinking:
      return "original-thinking"
    case .thinkingFive:
      return "thinking-five"
    case .thinkingNine:
      return "thinking-nine"
    case .roseOrbit:
      return "rose-orbit"
    case .rose:
      return "rose-curve"
    case .roseTwo:
      return "rose-two"
    case .roseThree:
      return "rose-three"
    case .roseFour:
      return "rose-four"
    case .lissajousDrift:
      return "lissajous-drift"
    case .lemniscateBloom:
      return "lemniscate-bloom"
    case .hypotrochoidLoop:
      return "hypotrochoid-loop"
    case .threePetalSpiral:
      return "three-petal-spiral"
    case .fourPetalSpiral:
      return "four-petal-spiral"
    case .fivePetalSpiral:
      return "five-petal-spiral"
    case .sixPetalSpiral:
      return "six-petal-spiral"
    case .butterflyPhase:
      return "butterfly-phase"
    case .cardioidGlow:
      return "cardioid-glow"
    case .cardioidHeart:
      return "cardioid-heart"
    case .heartWave:
      return "heart-wave"
    case .spiralSearch:
      return "spiral-search"
    case .fourierFlow:
      return "fourier-flow"
    }
  }
}
