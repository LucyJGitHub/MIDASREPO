     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Early Maturity Date')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVERLYMDT - Validate Early Maturity date                    *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             maturity date and confirms whether it has a valid *
      *             value. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR806147A          Date 21May18               *
      *  Prev Amend No. AR806147           Date 21May18               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3735            Date 20Jul04               *
      *                 CDL017 *Create     Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR806147A - Add validation so that an EM amendment with value*
      *              date = early maturity date can be authorised.    *
      *              (Child: AR806148)                                *
      *            - Applied for MD-48300.                            *
      *  AR806147 - Do not allow Early Maturity date to be less than  *
      *             the Value Date of any existing deal amendment     *
      *             for that deal or less than the Next Interest      *
      *             Payment date. Patterned from MMLDNIAMD.           *
      *             (Child: AR806148)                                 *
      *            - Applied for MD-48300.                            *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3735- Allow entry of a deal amendment with early maturity *
      *           date that is the same as the value date of the      *
      *           deal amendment                                      *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                                           AR806147
      ** ¦ F-specs                              ¦                                           AR806147
      ** ¦ =======                              ¦                                           AR806147
      ** +--------------------------------------+                                           AR806147
      *****************************************************************                     AR806147
      *                                                                                     AR806147
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)                                     AR806147
      *                                                                                     AR806147
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)                                     AR806147
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for nostros file
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** Define multibranch indicator field
     D RUNDAT          DS
     D  Rundate                8     10P 0
     D  MBIN                  13     13
                                                                                            AR806147
      ** Data structure for date in, to change format.                                      AR806147
     D                 DS                                                                   AR806147
     D  DateIn2                1      8  0                                                  AR806147
     D  @@YY                   1      4  0                                                  AR806147
     D  @@MM                   5      6  0                                                  AR806147
     D  @@DD                   7      8  0                                                  AR806147
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Parameters for ZDATE1
     D DateIn          S              6A
     D DayNoOut        S              5P 0
 
      * Return code for ZAVDATE call
     D @RTCDE          S              1A
     D @KEYF           S              3A
     D @KEYG           S             10A
     D @KEYH           S              1A
     D @MDYNO          S              5  0
 
      ** Deals file version of maturity date
     D IKMATD          S                   LIKE(@MDYNO)
     D BJDFIN          S              1A
     D BJLCCY          S              3A
     D BJSLCD          S              3A
     D BJRDNB          S              5  0
 
      ** Deal type from screen
     D DDTYPE          S              2A
      ** Deal currency from screen
     D DDCCY           S              3A
      ** Early Maturity date is received as a parameter
     D DDEMDT          S              6A
      ** Maturity date is received as a parameter
     D DDMdat          S              5  0
      ** Value date is received as a parameter
     D DDVdat          S              6A
      ** Early Maturity date is received as a parameter
     D IGEMDt          S              5P 0
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
      ** Warning message code 1 received as a parameter
     D WMsgid1         S                   LIKE(#MsgID)
 
      ** Payment error code
     D PMERCD          S            150A
      ** Our pay instructions
     D PMPONS          S             12A
      ** Payment settlement method
     D PMPSTM          S              2S 0
      ** Payment nostro
     D PMRONS          S             12A
      ** Receive settlement method
     D PMRSTM          S              2S 0
 
      ** Early Maturity Date Work Field
     D W1EMDATE        S              5  0
      ** Value Date Work Field
     D W1VDATE         S              5  0
 
      ** Location code for holiday checking
     D ZLOC            S              3A
      ** Holiday indicator
     D ZIND            S              1A
 
      ** Deal Amendment Value Date in Midas Dayno. format                                   AR806147
     D DeamValDat      S              5P 0                                                  AR806147
      *                                                                                     AR806147
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
     C                   RESET                   Msgid1
     C                   RESET                   WMsgid1
 
      **  Entry only valid for Deal Type 'EM'
     C     DDTYPE        IFNE      'EM'
     C     DDEMDT        ANDNE     *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0350'     Msgid1
     C                   ELSE
 
     C     DDTYPE        IFEQ      'EM'
 
      **  No Date Entered, this is an error.
     C     DDEMDT        IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0331'     Msgid1
     C                   ELSE
 
      **  Validate that the early maturity date is valid as a date.
     C                   RESET                   ReturnCode
     C                   CALLB     'ZAVDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    DDEMDT
     C                   PARM                    BJDfin
     C                   PARM                    @Mdyno
 
      **  If date is invalid...
     C     ReturnCode    IFEQ      'Error'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0128'     Msgid1
     C                   ELSE
 
      ** Must be -  Earlier than current Maturity Date
      **            Later than Value Date
      **            Later than or Equal to Current Run Date
      ** (Convert Dates Into Midas Day Number if not already)
 
     C                   MOVE      DDVDat        DateIn                         Value Date
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM                    DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFound
     C                   Z-ADD     DayNoOut      W1VDate
 
     C                   MOVE      DDEMDT        DateIn                         Early Maturity Date
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM                    DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFound
     C                   Z-ADD     DayNoOut      W1EMDate
      *
     C     W1EMDate      IFLT      RunDate
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0323'     Msgid1
     C                   ENDIF
      *
     C*****W1EMDate      IFLE      W1VDate                                                   BUG3735
     C     W1EMDate      IFLT      W1VDate                                                   BUG3735
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0324'     Msgid1
     C                   ENDIF
      *
     C     W1EMDate      IFGE      DDMDAT
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0325'     Msgid1
     C                   ENDIF
      *                                                                                     AR806147
      ** Check if the Early Maturity date is before the Next                                AR806147
      ** Interest Payment date - this is an error                                           AR806147
      *                                                                                     AR806147
     C                   MOVE      DDDLNO        DealNum           6 0                      AR806147
     C     DealNum       CHAIN     MMDEALLL                           65                    AR806147
      *                                                                                     AR806147
     C     *IN65         IFEQ      '0'                                                      AR806147
     C     W1EMDate      ANDLE     HKNIPD                                                   AR806147
     C                   EVAL      ErrorFound = 'Y'                                         AR806147
     C                   MOVEL     'MMM4010'     Msgid1                                     AR806147
     C                   ENDIF                                                              AR806147
      *                                                                                     AR806147
      ** Access the deal amendments file for the last amendment                             AR806147
      ** to the deal being processed.                                                       AR806147
      *                                                                                     AR806147
     C                   Z-ADD     0             DeamValDat                                 AR806147
      *                                                                                     AR806147
      ** Set value for key of file to be greater than value required.                       AR806147
      *                                                                                     AR806147
     C     @DEAMK        KLIST                                                              AR806147
     C                   KFLD                    @DEAMN            6 0                      AR806147
     C                   KFLD                    @VDYY             4 0                      AR806147
     C                   KFLD                    @VDMM             2 0                      AR806147
     C                   KFLD                    @VDDD             2 0                      AR806147
     C                   KFLD                    @DEAMS            3 0                      AR806147
      *                                                                                     AR806147
     C                   MOVE      HKDN38        @DEAMN                                     AR806147
     C                   MOVE      '9999'        @VDYY                                      AR806147
     C                   MOVE      '99'          @VDMM                                      AR806147
     C                   MOVE      '99'          @VDDD                                      AR806147
     C                   MOVE      '999'         @DEAMS                                     AR806147
      *                                                                                     AR806147
     C     @DEAMK        SETGT     MMLVDMLL                                                 AR806147
      *                                                                                     AR806147
      ** Read the previous record on file.  (Should be the latest deal                      AR806147
      ** amendment.)                                                                        AR806147
      *                                                                                     AR806147
     C                   READP     MMLVDMLL                               65                AR806147
     C     *IN65         IFEQ      '0'                                                      AR806147
     C     HNDA38        ANDEQ     HKDN38                                                   AR806147
     C                   Z-ADD     HNVDYY        @YEAR                                      AR806147
     C                   Z-ADD     HNVDMM        @MNTH                                      AR806147
     C                   Z-ADD     HNVDDD        @DAY                                       AR806147
      *                                                                                     AR806147
     C     @DATE         IFEQ      0                                                        AR806147
     C                   Z-ADD     0             DeamValDat                                 AR806147
     C                   ELSE                                                               AR806147
                                                                                            AR806147
     C                   Z-ADD     @DATE         DateIn2                                    AR806147
     C                   CALLB     'ZA0770'                                                 AR806147
     C                   PARM                    RetCodeOut       10                        AR806147
     C                   PARM                    DateIn2                                    AR806147
     C                   PARM                    BJDFIN                                     AR806147
     C                   PARM                    DateOut           6 0                      AR806147
     C                   MOVE      DateOut       @DAT              6 0                      AR806147
      *                                                                                     AR806147
     C                   CALLB     'ZA0270'                                                 AR806147
     C                   PARM                    @DAT                                       AR806147
     C                   PARM                    BJDFIN                                     AR806147
     C                   PARM                    @RTCDE            1                        AR806147
     C                   PARM                    DeamValDat                                 AR806147
     C                   ENDIF                                                              AR806147
     C                   ENDIF                                                              AR806147
      *                                                                                     AR806147
      ** If the new maturity date is not later than the value date,                         AR806147
      ** it is an error.                                                                    AR806147
      *                                                                                     AR806147
     C     W1EMDate      IFLE      DeamValDat                                               AR806147
     C     HNMTYP        ANDNE     'EM'                                                    AR806147A
     C                   EVAL      ErrorFound = 'Y'                                         AR806147
     C                   MOVEL     'MMM0136'     Msgid1                                     AR806147
     C                   ENDIF                                                              AR806147
 
     C                   ENDIF
 
     C     ErrorFound    IFNE      'Y'
 
     C     PMPSTM        IFEQ      01
     C     PMPSTM        OREQ      07
     C     PMPSTM        OREQ      08
 
      **  Find whether the date is a holiday in the deal currency
      **  at the pay nostro location.
      **  First find pay nostro location.
      *  (database error handling done in access program)
      * IF ERRORS OUTSTANDING IN SETTL.DETAILS, DON'T CALL ACCESS OBJ
 
     C     PMERCD        IFEQ      *BLANKS
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      DDCCY         @KEYB             3
     C                   PARM      *BLANKS       @KEYC             4
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      PMPONS        @KEYE             2
     C                   PARM      *BLANKS       @KEYF
     C                   PARM      *BLANKS       @KEYG
     C                   PARM      *BLANKS       @KEYH
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   MOVE      A7NOSN        ZLOC
      *
     C                   ELSE
     C                   MOVE      *BLANKS       ZLOC
     C                   ENDIF
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    @MDYNO
     C                   PARM                    DDCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
      *
      **  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM0134'     WMsgid1
     C                   ENDIF
     C                   ENDIF
      *
     C                   END
      *
      **  Find whether the date is a holiday in the local currency.
     C                   CALLB     'ZCHKH'
     C                   PARM                    @MDYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
      *
      **  If settlement method is not blank,00,01,07 or 08 and it is
      **  not a working day in the local currency, it is an error.
      **  (Only if not settled through a nostro)
     C     PMRSTM        IFNE      1
     C     PMRSTM        ANDNE     7
     C     PMRSTM        ANDNE     8
     C     PMPSTM        ORNE      1
     C     PMPSTM        ANDNE     7
     C     PMPSTM        ANDNE     8
      *
      **  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound    = 'Y'
     C                   MOVEL     'MMM0135'     WMsgid1
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Output valid maturity date
     C     ErrorFound    IFNE      'Y'
     C     DDEMDT        ANDNE     *BLANKS
     C     ErrorFound    OREQ      'Y'
     C     WarnFound     ANDEQ     'Y'
     C     DDEMDT        ANDNE     *BLANKS
     C                   Z-ADD     W1EMDate      IGEMDT
     C                   ELSE
     C                   Z-ADD     0             IGEMDT
     C                   ENDIF
 
      ** Return code set in /COPY
     C/COPY ZACPYSRC,SETRETCDE
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    WMsgid1
     C                   PARM                    DDMDAT
     C                   PARM                    DDVDAT
     C                   PARM                    DDTYPE
     C                   PARM                    BJLCCY
     C                   PARM                    BJDFIN
     C                   PARM                    BJSLCD
     C                   PARM                    DDEMDT
     C                   PARM                    IGEMDT
     C                   PARM                    DDDLNO            6                        AR806147
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
