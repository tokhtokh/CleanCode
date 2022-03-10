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
            val prefixLength = findCommonPrefix()
            val suffixLength = findCommonSuffix(prefixLength)
            
            compactExpected = compact(expected, prefixLength, suffixLength)
            compactActual = compact(actual, prefixLength, suffixLength)
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

    def private int findCommonSuffix(int prefixLength)
    {
        var suffixLength = 0
        for (; !suffixOverlapsPrefix(prefixLength, suffixLength); suffixLength++)
        {
            if (charFromEnd(expected, suffixLength) !== charFromEnd(actual, suffixLength))
            {
                return suffixLength
            }
        }
        return suffixLength
    }

    def private char charFromEnd(String s, int i)
    {
        return s.charAt(s.length() - i - 1)
    }

    def private boolean suffixOverlapsPrefix(int prefixLength, int suffixLength)
    {
        return actual.length() - suffixLength <= prefixLength || expected.length() - suffixLength <= prefixLength
    }

    def private int findCommonPrefix()
    {
        var prefixLength = 0
        var int end = Math.min(expected.length(), actual.length())
        for (; prefixLength < end; prefixLength++)
        {
            if (expected.charAt(prefixLength) !== actual.charAt(prefixLength))
            {
                return prefixLength
            }
        }
        return prefixLength
    }

    def private String compact(String s, int prefixLength, int suffixLength)
    {
        return new StringBuilder()
            .append(startingEllipsis(prefixLength))
            .append(startingContext(prefixLength))
            .append(DELTA_START)
            .append(delta(s, prefixLength, suffixLength))
            .append(DELTA_END)
            .append(endingContext(suffixLength))
            .append(endingEllipsis(suffixLength))
            .toString()
    }

    def private String startingEllipsis(int prefixLength)
    {
        return if (prefixLength > contextLength) ELLIPSIS else ""
    }

    def private String startingContext(int prefixLength)
    {
        var int contextStart = Math.max(0, prefixLength - contextLength)
        var int contextEnd = prefixLength
        return expected.substring(contextStart, contextEnd)
    }

    def private String delta(String s, int prefixLength, int suffixLength)
    {
        var int deltaStart = prefixLength
        var int deltaEnd = s.length() - suffixLength
        return s.substring(deltaStart, deltaEnd)
    }

    def private String endingContext(int suffixLength)
    {
        var int contextStart = expected.length() - suffixLength
        var int contextEnd = Math.min(contextStart + contextLength, expected.length())
        return expected.substring(contextStart, contextEnd)
    }

    def private String endingEllipsis(int suffixLength)
    {
        return (if (suffixLength > contextLength) ELLIPSIS else "" )
    }
}
