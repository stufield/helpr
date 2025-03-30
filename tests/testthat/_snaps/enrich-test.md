# `enrich_test()` S3 methods dispatch correctly

    Code
      x
    Message
      == Enrichment Tests ============================================================
      -- Counts Table ----------------------------------------------------------------
    Output
           v2
      v1    no yes
        no   4   3
        yes  2  11
      
    Message
      -- Hypergeometric --------------------------------------------------------------
      i Test-type            p-value
    Output
      
    Message
      * 1-sided              0.07765738
      * 2-sided              0.15531476
      * 1-sided mid          0.04244066
      * 2-sided mid          0.08488132
      * 2-sided min lik      0.12192982
      * 2-sided min lik mid* 0.08671311
    Output
      
    Message
      -- Fisher's Exact --------------------------------------------------------------
      i Alternative          two.sided
    Output
      
    Message
      * Odds Ratio           6.48649744
      * Odds Ratio p-value   0.12192982
      * OR CI95              [0.601, 107.532]
      ================================================================================

