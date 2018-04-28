     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Equation Currency Mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000089 - Equation Currency Mapping                         *
      *                                                               *
      *  Function:  This program Map the Currency in Equation         *
      *                                                               *
      *  Called By: SD000088 - Currency Mapping and update of Equation*
      *                        Currency File                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG14132           Date 18Jun07               *
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG14132 - New Currency codes do not show when               *
      *             opening  Consumer accounts                        *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 -  Database Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR   - Program exception error routine                    *
      *  *INZSR  - Initialisation Subroutine                          *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.  Use      *
      *  RESET for subsequent passes.                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
 
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      ** Program Status Data Structure
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      *  Data structure based on Midas users details file.
     D P@USER        E DS                  EXTNAME(MUSERDD)
      *
      *  After  Image based on Midas SD Currency codes File
     DAIMG           E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(A_)
      *
      *  Before Image based on Midas SD Currency codes File
     D BIMG          E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(B_)
      *
     D DSAIM           DS
     D VFAPP                   1      1
     D VFWSD                   2      5
     D VFRBR                   6      9
     D VFBID                  10     14
     D VFUID                  15     22
     D VFTTP                  23     23
     D VFBBN                  24     27
     D VFKCD                  28     32
     D VFINB                  33     44
     D SPARE1                 45     49
     D VFCUR                  50     69
     D VFCAB                  70     72
     D VFSCY                  73     75
     D VFCED                  76     76S 0
     D VFMTN                  77     79
     D VFNUS                  80     80
     D VFNUO                  81     81
     D VFDBR                  82     83
     D VFDDR                  84     85
     D VFPDR                  86     87
     D VFIDD                  88     88
     D VFCBR                  89     90
     D VFCDR                  91     92
     D VFIDC                  93     93
     D VFEB1                  94     94
     D SPARE2                 95    243
     D VFIND                 244    244
      *
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D TRGEVENT        S              1
     D IND21           S              3
     D IND11           S              3
     D IND16           S              3
     D IND32           S              3
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      *  MAIN PROCEDURE                                               *
      *****************************************************************
 
      *  Mapping for Equation
     C                   EVAL      VFAPP = 'D'
     C                   EVAL      VFWSD = 'MIDA'
      *
      *  CALL 'AOUSERR0' with following parameteres
     C                   CALL      'AOUSERR0'
      *  Input Parameters
     C                   PARM      *BLANK        P@APRC            7
     C                   PARM      '*KEY'        P@APOP            7
     C                   PARM                    PSUser           10
      *  Output Parameter
     C     P@USER        PARM      P@USER        DSSDY
      *
     C                   IF        P@APRC <> *Blanks
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE  =  'MUSERDD'
     C                   EVAL      DBKEY   =  PSUser
     C                   EVAL      DBASE   =  001
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C                   EVAL      VFRBR = DBRN
     C                   ENDIF
      *
     C                   EVAL      VFBID = %SUBST (PSUser:1:5)
     C                   EVAL      VFUID = %SUBST (PSUser:1:8)
     C                   EVAL      VFTTP = 'Y'
     C                   EVAL      VFBBN = '0000'
     C                   EVAL      VFKCD = '08' + %Char(A_A6ISON)
      *
      *  Insert trigger event
     C                   IF        (TRGEVENT = '1')
     C                   IF        (A_A6DLCI = 'N')
     C                   EVAL      IND21 = '21A'
     C                   ELSE
     C                   EVAL      IND21 = '*BLANKS'
     C                   ENDIF
      *
     C                   IF        (A_A6MDIN = 'D')
     C                   EVAL      IND11 = '11A'
     C                   ELSE
     C                   EVAL      IND11 = '*BLANKS'
     C                   ENDIF
      *
     C                   IF        (A_A6RDFC = 'N')
     C                   EVAL      IND16 = '16A'
     C                   ELSE
     C                   EVAL      IND16 = '*BLANKS'
     C                   ENDIF
      *
     C                   EVAL      IND32 = '32A'
      *
     C                   ENDIF
      *
      *  Amend trigger event
     C**********         IF        (TRGEVENT = '3')                                         BUG14132
     C                   IF        (TRGEVENT = '3' or TRGEVENT = '2')                       BUG14132
     C                   IF        (B_A6DLCI = 'N' and A_A6DLCI = 'Y')
     C                   EVAL      IND21 = '21X'
     C                   ENDIF
      *
     C                   IF        (B_A6DLCI = 'Y' and A_A6DLCI = 'N')
     C                   EVAL      IND21 = '21A'
     C                   ENDIF
      *
     C                   IF        (B_A6DLCI = A_A6DLCI)
     C                   EVAL      IND21 = *BLANKS
     C                   ENDIF
      *
     C                   IF        (B_A6MDIN = 'D' and A_A6MDIN = 'M')
     C                   EVAL      IND11 = '11X'
     C                   ENDIF
      *
     C                   IF        (B_A6MDIN = 'M' and A_A6MDIN = 'D')
     C                   EVAL      IND11 = '11A'
     C                   ENDIF
      *
     C                   IF        (B_A6MDIN = A_A6MDIN)
     C                   EVAL      IND11 = *BLANKS
     C                   ENDIF
      *
     C                   IF        (B_A6RDFC = 'N' and A_A6RDFC = 'Y')
     C                   EVAL      IND16 = '16X'
     C                   ENDIF
      *
     C                   IF        (B_A6RDFC = 'Y' and A_A6RDFC = 'N')
     C                   EVAL      IND16 = '16A'
     C                   ENDIF
      *
     C                   IF        (B_A6RDFC = A_A6RDFC)
     C                   EVAL      IND16 = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      IND32 = *BLANKS
     C                   ENDIF
      *
      *  Delete trigger event
     C**********         IF        (TRGEVENT = '2')                                         BUG14132
     C**********         EVAL      IND21 = *BLANKS                                          BUG14132
     C**********         EVAL      IND11 = *BLANKS                                          BUG14132
     C**********         EVAL      IND16 = *BLANKS                                          BUG14132
     C**********         EVAL      IND32 = *BLANKS                                          BUG14132
     C**********         ENDIF                                                              BUG14132
      *
     C                   EVAL      VFINB = %TRIM (%TRIM (IND21 + IND11) +
     C                                     %TRIM (IND16 + IND32))
     C                   EVAL      SPARE1= *BLANKS
     C                   EVAL      VFCUR = A_A6CYNM
     C                   EVAL      VFCAB = A_A6CYCD
     C                   EVAL      VFSCY = A_A6SWCY
     C                   EVAL      VFCED = A_A6NBDP
     C                   EVAL      VFMTN = A_A6CYCD
     C                   EVAL      VFNUS = %Char(A_A6TXND)
     C                   EVAL      VFNUO = %Char(A_A6TXND)
     C                   EVAL      VFDBR = *BLANKS
     C                   EVAL      VFDDR = *BLANKS
     C                   EVAL      VFIDD = *BLANKS
     C                   EVAL      VFCBR = *BLANKS
     C                   EVAL      VFCDR = *BLANKS
     C                   EVAL      VFIDC = *Blanks
     C                   EVAL      VFEB1 = X'3B'
     C                   EVAL      SPARE2= *BLANKS
     C                   EVAL      VFIND = *BLANKS
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   OUT       LDA
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
     C
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    AIMG
     C                   PARM                    BIMG
     C                   PARM                    TRGEVENT
     C                   PARM                    DSAIM
      *
      *
     C     *DTAARA       DEFINE                  LDA
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
