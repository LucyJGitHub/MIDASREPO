      *****************************************************************
      *                                                               *
      *  Midas - /Copy Member (GL0420)                                *
      *                                                               *
      *  GL0420IIP8 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. MD055507 *CREATE    Date 16Jun20              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055507 - GLC43 component failed due to undefined record    *
      *             type is found in file APOST                       *
      *           - Amendments to copy source GL0420IP11, commented   *
      *             out APOSTVB in I-spec                             *
      *           - Introduced new copy source GL0420IIP8, that adds  *
      *             complete record identifying codes for file APOSTVB*
      *                                                               *
      *****************************************************************
      *                                                                                     MD055507
     IAPOSTVB   NS  06    1 CP                                                              MD055507
      *                                                                                     MD055507
     I                                  1    1  RECI                                        MD055507
     I                                  2   16  APKEY                                       MD055507
     I                                  2    7  CNUM                                        MD055507
     I                                  8   10  CCY                                         MD055507
     I                                 11   14 0ACODQQ                                      MD055507
     I                                 15   16 0ACSQ                                        MD055507
     I                             P   33   35 0PSTD                                        MD055507
     I                             P   36   38 0VALD                                        MD055507
     I                                 39   43  TRAT                                        MD055507
     I                                 44   73  PNAR                                        MD055507
     I                             P   74   80 0PSTA                                        MD055507
     I                                 81   81 0DRCR                222223                  MD055507
     I                                 82   87  ASOC                                        MD055507
     I                                 88   95 0CHQN                    25                  MD055507
     I                                 96  102  SPOS                                        MD055507
     I                                103  105  BRCA                                        MD055507
     I                                106  106 0RIND                212120                  MD055507
     I                                124  124  ATYPA                                       MD055507
     I                                128  128  CUOR                                        MD055507
     I                                  1  170  LOTP                                        MD055507
     I                                317  319  XRFI                                        MD055507
     I                                320  329 0XRFN                                        MD055507
     I                                590  599 0ACOD                                        MD055507
     I*                                                                                     MD055507
     I**                                                                                    MD055507
     I*    RATE CHANGE POSTING                                                              MD055507
     I**                                                                                    MD055507
     I          NS  04    1 CR                                                              MD055507
     I                                  1    1  RECI                                        MD055507
     I                                  2   16  APKEY                                       MD055507
     I                                  2    7  CNUM                                        MD055507
     I                                  8   10  CCY                                         MD055507
     I                                 11   14 0ACODQQ                                      MD055507
     I                                 15   16 0ACSQ                                        MD055507
     I                             P   33   35 0PSTD                                        MD055507
     I                             P   36   38 0VALD                                        MD055507
     I                                 39   43  TRAT                                        MD055507
     I                                 44   73  PNAR                                        MD055507
     I                                 81   81 0DRCR                222223                  MD055507
     I                                 96  102  SPOS                                        MD055507
     I                                103  105  BRCA                                        MD055507
     I                                124  124  ATYPA                                       MD055507
     I                                128  128  CUOR                                        MD055507
     I                             P  147  152 7INTR                                        MD055507
     I                                153  154 0BRT                                         MD055507
     I                             P  155  160 7RTSP                                        MD055507
     I                                161  170 0ACOD                                        MD055507
     I                                  1  170  LOTP                                        MD055507
     I*                                                                                     MD055507
     I*                                                                                     MD055507
     I*    CATCHALL FOR DELETED RECORDS                                                     MD055507
     I**                                                                                    MD055507
     I          NS  11                                                                      MD055507
     I                                  2   16  APKEY                                       MD055507
      *****************************************************************
      * End of /COPY GL0420IP11                                       *
      *****************************************************************
