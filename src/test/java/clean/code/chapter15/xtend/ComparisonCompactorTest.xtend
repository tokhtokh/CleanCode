package clean.code.chapter15.xtend

import junit.framework.TestCase

class ComparisonCompactorTest extends TestCase
{
    def void testMessage()
    {
        var String failure = new ComparisonCompactor(0, "b", "c").formatCompactedComparison("a")
        assertTrue("a expected:<[b]> but was:<[c]>".equals(failure))
    }

    def void testStartSame()
    {
        var String failure = new ComparisonCompactor(1, "ba", "bc").formatCompactedComparison(null)
        assertEquals("expected:<b[a]> but was:<b[c]>", failure)
    }

    def void testEndSame()
    {
        var String failure = new ComparisonCompactor(1, "ab", "cb").formatCompactedComparison(null)
        assertEquals("expected:<[a]b> but was:<[c]b>", failure)
    }

    def void testSame()
    {
        var String failure = new ComparisonCompactor(1, "ab", "ab").formatCompactedComparison(null)
        assertEquals("expected:<ab> but was:<ab>", failure)
    }

    def void testNoContextStartAndEndSame()
    {
        var String failure = new ComparisonCompactor(0, "abc", "adc").formatCompactedComparison(null)
        assertEquals("expected:<...[b]...> but was:<...[d]...>", failure)
    }

    def void testStartAndEndContext()
    {
        var String failure = new ComparisonCompactor(1, "abc", "adc").formatCompactedComparison(null)
        assertEquals("expected:<a[b]c> but was:<a[d]c>", failure)
    }

    def void testStartAndEndContextWithEllipses()
    {
        var String failure = new ComparisonCompactor(1, "abcde", "abfde").formatCompactedComparison(null)
        assertEquals("expected:<...b[c]d...> but was:<...b[f]d...>", failure)
    }

    def void testComparisonErrorStartSameComplete()
    {
        var String failure = new ComparisonCompactor(2, "ab", "abc").formatCompactedComparison(null)
        assertEquals("expected:<ab[]> but was:<ab[c]>", failure)
    }

    def void testComparisonErrorEndSameComplete()
    {
        var String failure = new ComparisonCompactor(0, "bc", "abc").formatCompactedComparison(null)
        assertEquals("expected:<[]...> but was:<[a]...>", failure)
    }

    def void testComparisonErrorEndSameCompleteContext()
    {
        var String failure = new ComparisonCompactor(2, "bc", "abc").formatCompactedComparison(null)
        assertEquals("expected:<[]bc> but was:<[a]bc>", failure)
    }

    def void testComparisonErrorOverlapingMatches()
    {
        var String failure = new ComparisonCompactor(0, "abc", "abbc").formatCompactedComparison(null)
        assertEquals("expected:<...[]...> but was:<...[b]...>", failure)
    }

    def void testComparisonErrorOverlapingMatchesContext()
    {
        var String failure = new ComparisonCompactor(2, "abc", "abbc").formatCompactedComparison(null)
        assertEquals("expected:<ab[]c> but was:<ab[b]c>", failure)
    }

    def void testComparisonErrorOverlapingMatches2()
    {
        var String failure = new ComparisonCompactor(0, "abcdde", "abcde").formatCompactedComparison(null)
        assertEquals("expected:<...[d]...> but was:<...[]...>", failure)
    }

    def void testComparisonErrorOverlapingMatches2Context()
    {
        var String failure = new ComparisonCompactor(2, "abcdde", "abcde").formatCompactedComparison(null)
        assertEquals("expected:<...cd[d]e> but was:<...cd[]e>", failure)
    }

    def void testComparisonErrorWithActualNull()
    {
        var String failure = new ComparisonCompactor(0, "a", null).formatCompactedComparison(null)
        assertEquals("expected:<a> but was:<null>", failure)
    }

    def void testComparisonErrorWithActualNullContext()
    {
        var String failure = new ComparisonCompactor(2, "a", null).formatCompactedComparison(null)
        assertEquals("expected:<a> but was:<null>", failure)
    }

    def void testComparisonErrorWithExpectedNull()
    {
        var String failure = new ComparisonCompactor(0, null, "a").formatCompactedComparison(null)
        assertEquals("expected:<null> but was:<a>", failure)
    }

    def void testComparisonErrorWithExpectedNullContext()
    {
        var String failure = new ComparisonCompactor(2, null, "a").formatCompactedComparison(null)
        assertEquals("expected:<null> but was:<a>", failure)
    }

    def void testBug609972()
    {
        var String failure = new ComparisonCompactor(10, "S&P500", "0").formatCompactedComparison(null)
        assertEquals("expected:<[S&P50]0> but was:<[]0>", failure)
    }
}
