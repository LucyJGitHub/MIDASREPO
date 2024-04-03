      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0420)                                *
      *                                                               *
      *  UUC102_012 - Balance Statements (A/C Formats)                *
      *                                                               *
      *  Last Amend No. MD059313*CREATE Date 07Feb22                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD059313 - CFSB not updated on ACCNTAB when UUC102 is OFF.   *
      *           - Ensure XXAPOSV1 definition includes all formats to*
      *             avoid undefined type error.                       *
      *             Replace hooks GL0420IP11 and GL0420IIP2 with      *
      *             UUC102_012.                                       *
      *                                                               *
      *****************************************************************
     IXXAPOSV1  NS  06    1 CP
      *
     I                                  1    1  RECI
     I                                  2   16  APKEY
     I                                  2    7  CNUM
     I                                  8   10  CCY
     I                                 11   14 0ACODQQ
     I                                 15   16 0ACSQ
     I                             P   33   35 0PSTD
     I                             P   36   38 0VALD
     I                                 39   43  TRAT
     I                                 44   73  PNAR
     I                             P   74   80 0PSTA
     I                                 81   81 0DRCR                222223
     I                                 82   87  ASOC
     I                                 88   95 0CHQN                    25
     I                                 96  102  SPOS
     I                                103  105  BRCA
     I                                106  106 0RIND                212120
     I                                124  124  ATYPA
     I                                128  128  CUOR
     I                                  1  170  LOTP
     I                                171  289  LOTP2
     I                                317  319  XRFI
     I                                320  329 0XRFN
     I                                590  599 0ACOD
      *
      **  RATE CHANGE POSTING
      *
     I          NS  04    1 CR
     I                                  1    1  RECI
     I                                  2   16  APKEY
     I                                  2    7  CNUM
     I                                  8   10  CCY
     I                                 11   14 0ACODQQ
     I                                 15   16 0ACSQ
     I                             P   33   35 0PSTD
     I                             P   36   38 0VALD
     I                                 39   43  TRAT
     I                                 44   73  PNAR
     I                                 81   81 0DRCR                222223
     I                                 96  102  SPOS
     I                                103  105  BRCA
     I                                124  124  ATYPA
     I                                128  128  CUOR
     I                             P  147  152 7INTR
     I                                153  154 0BRT
     I                             P  155  160 7RTSP
     I                                161  170 0ACOD
     I                                  1  170  LOTP
      *
      **   CATCHALL FOR DELETED RECORDS
      *
     I          NS  11
     I                                  2   16  APKEY
      *
