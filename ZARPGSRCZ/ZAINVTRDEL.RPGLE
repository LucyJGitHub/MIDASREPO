     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Invalid transaction deletion')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZAINVTRDEL - INVALID TRANSACTION DELETION                    *
      *                                                               *
      *  Function:  This screen function allows invalid               *
      *             transactions to be deleted.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 168526             Date 11Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004  *CREATE    Date 01Sep98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  164819 - Replace call of ZA0240 with call to ZA0340 to allow *
      *           specified message file to be used.                  *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZAINVTRDDFCF   E             WORKSTN
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
      ** API transaction errors by FO ID(40-long) and Timestamp                               CGL029
     FZATRNERRL2IF   E           K DISK    RENAME(ZATRNERRD0:ZATRNERRD2)                      CGL029
     F                                     INFSR(*PSSR)                                       CGL029
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
                                                                                              CGL029
     D DDFO40          S             40A                                                      CGL029
     D WkGL            S              1A                                                      CGL029
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D RUNDAT          DS            13
     D  DDRUNA                 1      7
     D  DATFMT                12     12
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp
     D DDTMESTP        S             26Z
      **   Timestamp
     D                 DS
     D D@TMESTP                1     26A
     D DDYERT                  1      4A
     D DDMTHT                  6      7A
     D DDDAYT                  9     10A
     D DDTIMA                 12     19A
      **   Date of arrival
     D                 DS
     D DDDATA                  1     10A
     D DDDAYA                  1      2A
     D DDSLA1                  3      3A
     D DDMTHA                  4      5A
     D DDSLA2                  6      6A
     D DDYERA                  7     10A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * Write/Read Screen
      *
     C                   EXSR      WRSCRN
      *
      * DO WHILE COMMAND 3, 10 OR 12 NOT TAKEN
      *
     C     @INKC         DOWEQ     '0'
     C     @INKJ         ANDEQ     '0'
     C     @INKL         ANDEQ     '0'
      *
      * Write/Read Screen
      *
     C                   EXSR      WRSCRN
     C                   END
      *
      *  Close down program
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
      *
      **  Clear screen message queue.
      *
     C                   CALL      'ZA0250'
      *
      *  Return
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* WRSCRN - WRITE/READ SCREEN
     C*****************************************************************
     C     WRSCRN        BEGSR
      *
     C                   TIME                    DDTIME
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   WRITE     #RCDDTL1
      *
     C                   READ      #RCDDTL1                               99
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
                                                                                              CGL029
      ** If called from GL, set flag and concatenate front office with associated             CGL029
      ** front office id                                                                      CGL029
                                                                                              CGL029
     C                   EVAL      WkGL = 'N'                                                 CGL029
     C                   IF        RetCodeIn = 'GL        '                                   CGL029
     C                   EVAL      WkGL = 'Y'                                                 CGL029
     C                   EVAL      DDFO40 = DDFOTI + DDFOAS                                   CGL029
     C                   EVAL      RetCodeIn = *BLANKS                                        CGL029
     C                   ELSE                                                                 CGL029
     C                   EVAL      DDFO40 = DDFOTI                                            CGL029
     C                   EVAL      DDFOAT = DDFOAS                                            CGL029
     C                   ENDIF                                                                CGL029
      *
      * CLEAR OUTPUTS
      *
     C                   MOVEL     *BLANK        RetCodeIn
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKJ
     C                   MOVE      '0'           @INKL
      *
      ** Format date and time of arrival for display
      *
     C                   MOVE      DDTMESTP      D@TMESTP
     C                   MOVEL     DDDAYT        DDDAYA
     C                   MOVEL     DDMTHT        DDMTHA
     C                   MOVEL     DDYERT        DDYERA
     C                   MOVE      '/'           DDSLA1
     C                   MOVE      '/'           DDSLA2
      *
      ** Read error messages for transaction
      *
     C                   IF        WkGL = 'Y'                                                 CGL029
     C     ZATRNKD2      SETLL     ZATRNERRD2                                                 CGL029
     C     ZATRNKD2      READE     ZATRNERRD2                             99                  CGL029
     C                   ELSE                                                                 CGL029
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   ENDIF                                                                CGL029
      *
      ** Add error message to subfile
      *
     C     *IN99         DOWEQ     '0'
     C                   MOVEL     ABMSGID       @WERR             7
     C                   MOVEL     ABMSGFILE     @WERRFL          10            164819
     C                   EXSR      ERROR
                                                                                              CGL029
      ** If coming from GL, use ZATRNERRL2 file instead                                       CGL029
                                                                                              CGL029
     C                   IF        WkGL = 'Y'                                                 CGL029
     C     ZATRNKD2      READE     ZATRNERRD2                             99                  CGL029
     C                   ELSE                                                                 CGL029
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   ENDIF                                                                CGL029
                                                                                              CGL029
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************         164819
      * ERROR    - CALL PROGRAM ZA0240 TO OUTPUT ERROR MESSAGES       *         164819
     C*****************************************************************         164819
     C*****ERROR         BEGSR                                                  164819
     C*                                                                         164819
     C***Display error message                                                  164819
     C*                                                                         164819
     C*******************MOVEL     *BLANK        ZAMSID           10            164819
     C*******************MOVEL     @WERR         ZAMSID                         164819
     C*******************CALL      'ZA0240'                                     164819
     C*******************PARM                    ZAMSID                         164819
     C*                                                                         164819
     C*******************ENDSR                                                  164819
     C*****************************************************************         164819
      * ERROR    - CALL PROGRAM ZA0340 TO OUTPUT ERROR MESSAGES       *         164819
     C*****************************************************************         164819
     C     ERROR         BEGSR                                                  164819
     C*                                                                         164819
     C*  Display error message                                                  164819
     C*                                                                         164819
     C                   MOVEL     *BLANK        ZAMSFL           10            164819
     C                   MOVEL     *BLANK        ZAMSID           10            164819
     C                   MOVEL     @WERRFL       ZAMSFL                         164819
     C                   MOVEL     @WERR         ZAMSID                         164819
     C                   CALL      'ZA0340'                                     164819
     C                   PARM                    ZAMSFL                         164819
     C                   PARM                    ZAMSID                         164819
     C*                                                                         164819
     C                   ENDSR                                                  164819
     C********************************************************************      164819
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Parameters passed into the program
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Action code
     C                   PARM                    DDACTN            1
      *
      * Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    DDFOTI           20
     C**********         PARM                    DDFOAT           20                          CGL029
     C                   PARM                    DDFOAS           20                          CGL029
      *
      * Timestamp
     C                   PARM                    DDTMESTP
      *
      * Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM                    DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM                    DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM                    DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM                    DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM                    DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM                    DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM                    DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM                    DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM                    DDFLD9           35
      *
      * OUTPUTS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
      *
      **  Run date in DDMMMYY
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFOTI
     C                   KFLD                    DDTMESTP
      *                                                                                       CGL029
     C     ZATRNKD2      KLIST                                                                CGL029
     C                   KFLD                    DDFO40                                       CGL029
     C                   KFLD                    DDTMESTP                                     CGL029
      *
      ** Initialize program name
      *
     C                   MOVEL     'ZAINVTRDEL'  DBPGM
     C                   MOVEL     'ZAINVTRDEL'  ##PGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
