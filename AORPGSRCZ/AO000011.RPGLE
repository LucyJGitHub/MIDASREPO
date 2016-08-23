     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AO AOSPOSU0 trace file from Java')
      *****************************************************************
      *                                                               *
      *  Midas - Access object Module                                 *
      *                                                               *
      *  AO000011 - Midas AO AOSPOSU0 trace file from Java            *
      *                                                               *
      *  Function:  This program will dump the parameters from JAVA   *
      *   Phase: I/C                                                  *
      *                                                               *
      *  Called By: AOC000010 - Midas AO AOSPOSU0 wrapper for Retail  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CAP205             Date 19Feb10               *
      *  Prev Amend No. CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247922             Date 05Jun07               *
      *                 BUG13193           Date 13Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239164             Date 30Mar06               *
      *                 238797             Date 08Mar06               *
      *                 CSD027A            Date 04May06               *
      *                 236189  *CREATE    Date 09Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  247922 - Applied core fix 239164.                            *
      *  BUG13193 - Make movement amount negative if narrative is     *
      *             starts with text 'CHARGES'.                       *
      *  239164 - New field added to PF/AOSPOSPD. Recompiled.         *
      *  238797 - MidasPlus trace program. Applied fix 236189.        *
      *  CSD027A - Conversion of customer number to alpha.            *
      *  236189  - MidasPlus trace program.                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FAOSPOSPD  O    E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D I#DTA           DS           256
      *
      ** Account type
     D  AOATYP                 1      1
 
      ** Full General Ledger - CNUM/CCY/ACOD/ACSQ
     D  AOACCT                 2     19
     D**AOCNU1**               2      7  0                                                   CSD027A
     D  AOCNU1                 2      7                                                      CSD027A
     D  AOCCY1                 8     10
     D  AOACS1                15     16  0
     D  AOBRC1                17     19
 
      ** Nostro number
      ** Full Nostro - CCY/NOSN
      ** Retail Number
     D  AONOSN                 2      3  0
     D  AONOS                  2      6
     D  AOACNO                 2     11  0
 
      ** Partial Account - CNUM/ACOD/ACSQ
     D**AOCNUM**               2      7  0                                                   CSD027A
     D  AOCNUM                 2      7                                                      CSD027A
     D  AOACSQ                12     13  0
 
      ** Branch of account if Partial
      ** OLPOS Incoming/Outgoing Indicator 'I' or 'O' or ' '; ' ' no OLPOS update
     D  AOBRCA                14     16
     D  AOIO                  24     24
 
      ** Currency of transaction
      ** Transaction Type
      ** Transaction Narrative
      ** Cheque Number
     D  AOCCY                 25     27
     D  AOTRYP                28     29
     D  AONARR                30     59
     D  AOCHQN                60     67  0
 
      ** FT transaction reference
      ** DL/LE/GL/RE transaction reference
      ** Movement amount
     D  AOPREF                68     82
     D  AOTRN                 83     88
     D  AOAMT                 89     96P 0
 
      ** Processing indicators Not blank = no update;  ' ' = Update
      **   Prono update indicator
      **   Olpos update indicator
      **   Memos update indicator
      **   Rsacmtpd write indicator
     D  AOPRON                97     97
     D  AOOLPS                98     98
     D  AOMEMS                99     99
     D  AORSAC               100    100
 
      ** Module
      ** Olpos record number to update; '01' for FX; '02' for Int; '03' for MM
      ** FT Memos ledger balance override
     D  AOMOD                101    102
     D  AOOLRC               103    104
     D  AOFTOV               105    105
 
      ** Value date
      ** Posting date
      ** Override posting date correction for forward valued items
     D  AOVDAT               106    108P 0
     D  AOPSTD               109    111P 0
     D  AOPSTO               112    112
 
      ** Indicator to show if removal allowed Y, N or " "
      ** Removal set number
      ** Removal type "C" = Credit entries; "D" = Debit entries
     D  AORPST               113    113
     D  AORPNB               114    116  0
     D  AORTYP               117    117
 
      ** Booking branch
     D  AOBBRN               118    120
     D  AOACO1               121    130  0
     D  AOACOD               131    140  0
      ** Other Transaction Reference                                                          CAP204
     D  I#OTR1               141    160                                                       CAP204
     D  AOMTYP               161    161                                                       CAP205
 
      ** Time data structure
     D                 DS
     D  @XTIME                 1      6  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D RUNBEFORE       S              1
     D DecDataErr      C                   907                                                239164
     D Num1            S             15P 0                                                    239164
     D Num2            S              5P 0                                                    239164
     D Num3            S              5P 0                                                    239164
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    ARTCD             7            Return Code
     C                   PARM                    PBUFC             1            AOSPOSU0 chnge PDATA
     C                   PARM                    PTYPE             4            API Type      239164
     C                   PARM                    PRTCD             7            Ret Code from Java
     C                   PARM                    PACTN             8            Action Code frm Java
     C                   PARM                    PDATA           256            Buffer from Java
     C                   PARM                    PJRTC           256            Java retcode  239164
     C                   PARM                    PIGDC             1            Ignore Dec er 239164
 
     C                   MOVE      *BLANKS       ARTCD
     C                   CLEAR                   AOBUFF
     C                   CLEAR                   AOJRTC                                       239164
     C                   CLEAR                   I#DTA
 
     C                   MOVEL     PSJobName     AOJNAM
     C                   MOVEL     PSUser        AOJUSR
     C                   MOVEL     PSJobNo       AOJNUM
     C                   MOVEL     PSDate        AODATE
     C                   TIME                    @XTIME
     C                   MOVEL     @XTIME        AOTIME
 
     C                   MOVEL     PTYPE         AOTYPE                                       239164
     C                   MOVEL     PRTCD         AORTCD
     C                   MOVEL     PACTN         AOACTN
     C                   MOVEL     PJRTC         AOJRTC                                       239164
 
     C     PIGDC         IFNE      'Y'                                                        239164
     C                   monitor                                                              239164
     C**********         MOVEL     PDATA         I#DTA                                        239164
     C                   EVAL      I#DTA =  PDATA                                             239164
     C                   IF        %SUBST(AONARR:1:7) = 'CHARGES'                           BUG13193
     C                             AND AOAMT > 0                                            BUG13193
     C                   EVAL      AOAMT = AOAMT * -1                                       BUG13193
     C                   EVAL      PDATA = I#DTA                                            BUG13193
     C                   ENDIF                                                              BUG13193
                                                                                              239164
     C                   ON-ERROR  DecDataErr                                                 239164
     C                   CLEAR                   I#DTA                                        239164
     C                   Z-ADD     *ZEROS        AOAMT                                        239164
     C                   Z-ADD     *ZEROS        AOVDAT                                       239164
     C                   Z-ADD     *ZEROS        AOPSTD                                       239164
     C                   MOVEL     'DEC ERR'     AORTCD                                       239164
     C                   endmon                                                               239164
                                                                                              239164
     C                   monitor                                                              239164
     C                   EVAL      Num1 = AOAMT                                               239164
     C                   EVAL      Num2 = AOVDAT                                              239164
     C                   EVAL      Num2 = AOPSTD                                              239164
                                                                                              239164
     C                   ON-ERROR  DecDataErr                                                 239164
     C                   Z-ADD     9999999999999 AOAMT                                        239164
     C                   Z-ADD     99999         AOVDAT                                       239164
     C                   Z-ADD     99999         AOPSTD                                       239164
     C                   MOVEL     'DEC ERR'     AORTCD                                       239164
     C                   Eval      AOJRTC = 'Decimal Data Error +                             239164
     C                              Occured on Amount or Date'                                239164
     C                   endmon                                                               239164
                                                                                              239164
     C                   ENDIF                                                                239164
     C                   MOVEL     PBUFC         AOBUFC
     C                   MOVEL     PDATA         AOBUFF
     C                   WRITE     AOSPOSP0
 
     C                   MOVE      '1'           *INLR                                        239164
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   MOVE      '*A11ER*'     ARTCD
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /EJECT
