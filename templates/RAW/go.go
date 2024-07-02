/* [prompt] */
/* ==== SOLUTION ==== */
/* [solution] */

/* ==== TEST ==== */
package main
import "testing"

var METADATA = map[string]string{
	"author":  "your-initials",
	"dataset": "test",
}

func TestCandidate(t *testing.T) {
	testCases := []struct {
		inputNums     []float64
		inputThreshold float64
		expected      bool
	}{
		/* examples */
		{[]float64{1.0, 2.0, 3.9, 4.0, 5.0, 2.2}, 0.3, true},

		/* cases */
		{[]float64{1.0, 2.0, 3.9, 4.0, 5.0, 2.2}, 0.05, false},
	}

	for _, tc := range testCases {
		result := candidate(tc.inputNums, tc.inputThreshold)
		if result != tc.expected {
			t.Errorf("candidate(%v, %v) = %v; expected %v", tc.inputNums, tc.inputThreshold, result, tc.expected)
		}
	}
}

/* ==== DEFINITION ==== */
/* [definition] */