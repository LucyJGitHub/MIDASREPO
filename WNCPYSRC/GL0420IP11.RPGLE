      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0420)                                *
      *                                                               *
      *  GL0420IP11 - Balance Statements (A/C Formats)                *
      *                                                               *
      *  Last Amend No. MD059313        Date 07Feb22                  *
      *  Prev Amend No. UUC102 *CREATE  Date 16Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD059313 - CFSB not updated on ACCNTAB when UUC102 is OFF.   *
      *           - Ensure XXAPOSV1 definition includes all formats to*
      *             avoid undefined type error.                       *
      *             Replace hooks GL0420IP11 and GL0420IIP2 with      *
      *             UUC102_012.                                       *
      *  UUC102 - Upgrade of CAR UUC063 to BF Midas 2.1               *
      *           UUC063 - Balance Statement Enhancement              *
      *                                                               *
      *****************************************************************
     I*XXAPOSV1* NS  06    1 CP                                                             MD059313
      **********                                                                            MD059313
0167 I**********                        1    1  RECI                                        MD059313
     I**********                        2   16  APKEY                                       MD059313
0168 I**********                        2    7  CNUM                                        MD059313
0169 I**********                        8   10  CCY                                         MD059313
     I**********                       11   14 0ACODQQ                                      MD059313
0171 I**********                       15   16 0ACSQ                                        MD059313
0173 I**********                   P   33   35 0PSTD                                        MD059313
0174 I**********                   P   36   38 0VALD                                        MD059313
0175 I**********                       39   43  TRAT                                        MD059313
0176 I**********                       44   73  PNAR                                        MD059313
0177 I**********                   P   74   80 0PSTA                                        MD059313
0178 I**********                       81   81 0DRCR                                        MD059313
0179 I**********                       82   87  ASOC                                        MD059313
0180 I**********                       88   95 0CHQN                                        MD059313
0181 I**********                       96  102  SPOS                                        MD059313
0182 I**********                      103  105  BRCA                                        MD059313
0183 I**********                      106  106 0RIND                                        MD059313
0184 I**********                      124  124  ATYPA                                       MD059313
0185 I**********                      128  128  CUOR                                        MD059313
     I**********                        1  170  LOTP                                        MD059313
     I**********                      317  319  XRFI                                        MD059313
     I**********                      320  329 0XRFN                                        MD059313
     I**********                      590  599 0ACOD                                        MD059313
