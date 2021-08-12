      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420IIP8 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (C) Copyright Finastra Internatonal Limited 2020             *
      *                                                               *
      *  Last Amend No. MD055520 *CREATE   Date 28Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055520 - GLC43 failure in GBFBUAG. Undefined record type.  *
      *             Amend to /Copy GL0420IP11 to comment out APOSTVB  *
      *             and /Copy GL0420IIP8 to add record format for     *
      *             APOSTVB.                                          *
      *                                                               *
      *****************************************************************
      *                                                                                     MD055520
     IAPOSTVB   NS  06    1 CP                                                              MD055520
      *                                                                                     MD055520
     I                                  1    1  RECI                                        MD055520
     I                                  2   16  APKEY                                       MD055520
     I                                  2    7  CNUM                                        MD055520
     I                                  8   10  CCY                                         MD055520
     I                                 11   14 0ACODQQ                                      MD055520
     I                                 15   16 0ACSQ                                        MD055520
     I                             P   33   35 0PSTD                                        MD055520
     I                             P   36   38 0VALD                                        MD055520
     I                                 39   43  TRAT                                        MD055520
     I                                 44   73  PNAR                                        MD055520
     I                             P   74   80 0PSTA                                        MD055520
     I                                 81   81 0DRCR                222223                  MD055520
     I                                 82   87  ASOC                                        MD055520
     I                                 88   95 0CHQN                    25                  MD055520
     I                                 96  102  SPOS                                        MD055520
     I                                103  105  BRCA                                        MD055520
     I                                106  106 0RIND                212120                  MD055520
     I                                124  124  ATYPA                                       MD055520
     I                                128  128  CUOR                                        MD055520
     I                                  1  170  LOTP                                        MD055520
     I                                317  319  XRFI                                        MD055520
     I                                320  329 0XRFN                                        MD055520
     I                                590  599 0ACOD                                        MD055520
     I*                                                                                     MD055520
     I**                                                                                    MD055520
     I*    RATE CHANGE POSTING                                                              MD055520
     I**                                                                                    MD055520
     I          NS  04    1 CR                                                              MD055520
     I                                  1    1  RECI                                        MD055520
     I                                  2   16  APKEY                                       MD055520
     I                                  2    7  CNUM                                        MD055520
     I                                  8   10  CCY                                         MD055520
     I                                 11   14 0ACODQQ                                      MD055520
     I                                 15   16 0ACSQ                                        MD055520
     I                             P   33   35 0PSTD                                        MD055520
     I                             P   36   38 0VALD                                        MD055520
     I                                 39   43  TRAT                                        MD055520
     I                                 44   73  PNAR                                        MD055520
     I                                 81   81 0DRCR                222223                  MD055520
     I                                 96  102  SPOS                                        MD055520
     I                                103  105  BRCA                                        MD055520
     I                                124  124  ATYPA                                       MD055520
     I                                128  128  CUOR                                        MD055520
     I                             P  147  152 7INTR                                        MD055520
     I                                153  154 0BRT                                         MD055520
     I                             P  155  160 7RTSP                                        MD055520
     I                                161  170 0ACOD                                        MD055520
     I                                  1  170  LOTP                                        MD055520
     I*                                                                                     MD055520
     I*                                                                                     MD055520
     I*    CATCHALL FOR DELETED RECORDS                                                     MD055520
     I**                                                                                    MD055520
     I          NS  11                                                                      MD055520
     I                                  2   16  APKEY                                       MD055520
