package clean.code.chapter15.xtend

import clean.code.chapter15.Assert

class ComparisonCompactor
{
    static final String ELLIPSIS = "..."
    static final String DELTA_END = "]"
    static final String DELTA_START = "["
    int contextLength
    String expected
    String actual
    int prefixLength
    int suffixLength

    new(int contextLength, String expected, String actual)
    {
        this.contextLength = contextLength
        this.expected = expected
        this.actual = actual
    }

    def String formatCompactedComparison(String message)
    {
        var String compactExpected = expected
        var String compactActual = actual
        if (shouldBeCompacted())
        {
            findCommonPrefixAndSuffix()
            compactExpected = compact(expected)
            compactActual = compact(actual)
        }
        return Assert.format(message, compactExpected, compactActual)
    }

    def private boolean shouldBeCompacted()
    {
        return !shouldNotBeCompacted()
    }

    def private boolean shouldNotBeCompacted()
    {
        return expected === null || actual === null || expected.equals(actual)
    }

    def private void findCommonPrefixAndSuffix()
    {
        findCommonPrefix()
        suffixLength = 0
        for (; !suffixOverlapsPrefix(); suffixLength++)
        {
            if (charFromEnd(expected, suffixLength) !== charFromEnd(actual, suffixLength))
            {
                return
            }
        }
    }

    def private char charFromEnd(String s, int i)
    {
        return s.charAt(s.length() - i - 1)
    }

    def private boolean suffixOverlapsPrefix()
    {
        return actual.length() - suffixLength <= prefixLength || expected.length() - suffixLength <= prefixLength
    }

    def private void findCommonPrefix()
    {
        prefixLength = 0
        var int end = Math.min(expected.length(), actual.length())
        for (; prefixLength < end; prefixLength++)
        {
            if (expected.charAt(prefixLength) !== actual.charAt(prefixLength))
            {
                return
            }
        }
    }

    def private String compact(String s)
    {
        return new StringBuilder().append(startingEllipsis()).append(startingContext()).append(DELTA_START).append(
            delta(s)).append(DELTA_END).append(endingContext()).append(endingEllipsis()).toString()
    }

    def private String startingEllipsis()
    {
        return if (prefixLength > contextLength) ELLIPSIS else ""
    }

    def private String startingContext()
    {
        var int contextStart = Math.max(0, prefixLength - contextLength)
        var int contextEnd = prefixLength
        return expected.substring(contextStart, contextEnd)
    }

    def private String delta(String s)
    {
        var int deltaStart = prefixLength
        var int deltaEnd = s.length() - suffixLength
        return s.substring(deltaStart, deltaEnd)
    }

    def private String endingContext()
    {
        var int contextStart = expected.length() - suffixLength
        var int contextEnd = Math.min(contextStart + contextLength, expected.length())
        return expected.substring(contextStart, contextEnd)
    }

    def private String endingEllipsis()
    {
        return (if (suffixLength > contextLength) ELLIPSIS else "" )
    }
}
