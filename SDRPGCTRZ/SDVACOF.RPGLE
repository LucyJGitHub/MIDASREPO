     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Account Officer')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVACOF  - Validate Account Officer                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. HUT113             Date 01Apr20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 01Apr99               *
      *                                    Date DDMmmYY               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *  HUT113 - Full PB Functionality in FM                         *
      *           (Upgrade HUT026 to FM2.1 SP22)                      *
      *           Addition of hooks HUT113_060 to HUT113_064          *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************

      ** Midas SD Account Officers
     FSDACOFL1  IF   E           K DISK
     F                                     RENAME(@AZREBO:ACCOFFS)

      ** Midas SD Portfolio Management Customer Details Retrieval
     FSDPLCSL1  IF   E           K DISK
     F                                     RENAME(@PLCSL1:PORTCUS)

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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D/COPY WNCPYSRC,HUT113_060
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D/COPY WNCPYSRC,HUT113_061

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

      ** Initialization

     C                   MOVE      *BLANK        RetCodeIn

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx

      *
      ** VALIDATION
      *
     C                   EXSR      ACOCV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDACOCOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - Account Officer
      *****************************************************************
     C     ACOCV         BEGSR

      * If account officer entered, must be on file
     C     DDACOC        IFNE      *BLANK

     C/COPY WNCPYSRC,HUT113_062                                                         HUT113

     C     DDACOC        CHAIN     ACCOFFS                            90

     C     *IN90         IFEQ      '1'
     C                   MOVE      'N'           DDACOCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACOC'      FldNamXAr(Idx)
     C                   MOVEL     'USR0057'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   ENDIF

      * If module Portfolio Management is on
      * and customer is on portfolio management file
      * account officer must be entered
     C     BGPFMG        IFEQ      'Y'
     C     DDCUSN        CHAIN     PORTCUS                            90

     C     *IN90         IFEQ      '0'
     C     DDACOC        ANDEQ     *BLANK
     C                   MOVE      'N'           DDACOCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACOC'      FldNamXAr(Idx)
     C                   MOVEL     'USR2838'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Account Officer (2A)
      ** Customer Number (6A)
      ** Portfolio Management (1A)
      *
     C                   PARM                    DDACOC            2
     C                   PARM                    DDCUSN            6
     C                   PARM                    BGPFMG            1
      *
     C/COPY WNCPYSRC,HUT113_063                                                         HUT113
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Account Officer - OK
     C                   PARM                    DDACOCOK          1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY WNCPYSRC,HUT113_064                                                         HUT113

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
