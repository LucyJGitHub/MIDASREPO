     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Value Date')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEVVLDT01 - Validate Securities Prices Value Date field      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060  *CREATE    Date 07Oct00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP060 - Midas APIs, Full Security Prices API                *
      *                                                               *
      *****************************************************************
 
     FPMAPOSLL  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Rundat
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** EXTERNAL DS FOR SECURITIES TRADING DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
      ** Switchable features details                                                          CSC011
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Error flag passed back from ZDATE1
     D ErrorFlag       S              1A
 
      ** Midas day number
     D ZDAYNO          S              5P 0
                                                                                              CSC011
      ** Fields defined for Enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(AGRDNB)                                       CSC011
                                                                                              CSC011
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
     C**********         MOVEL     DDPCNM        PCNM              6 0                        CSD027
     C                   MOVEL     DDPCNM        PCNM              6                          CSD027
      *
      * Initialise output fields
     C                   MOVEL     *BLANK        PVDT
     C*
     C* Value date field
     C*
     C     DDPVDT        IFNE      *BLANKS
     C*
     C* Check valid date
     C*
     C                   MOVE      DDPVDT        DATEN             6 0
     C                   MOVE      DATEN         DATEA             6
     C     DDPVDT        IFNE      DATEA
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDPVDT'
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0816'
     C                   EVAL      DDVDTOK   = 'N'
     C                   ELSE
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA
     C                   PARM      *ZEROS        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDPVDT'
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0816'
     C                   EVAL      DDVDTOK   = 'N'
     C                   ELSE
     C*
     C* Check date is not prior to Back Value Period
     C*
     C*****AGRDNB        SUB       BVBVP         WBKVP             6 0                        CSC011
     C     WRunday       SUB       BVBVP         WBKVP             6 0                        CSC011
     C     ZDAYNO        IFLT      WBKVP
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDPVDT'
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0817'
     C                   EVAL      DDVDTOK   = 'N'
     C                   ELSE
     C*
     C* Check not after run date
     C*
     C*****ZDAYNO        IFGT      AGRDNB                                                     CSC011
     C     ZDAYNO        IFGT      WRunday                                                    CSC011
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDPVDT'
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0818'
     C                   EVAL      DDVDTOK   = 'N'
     C                   ELSE
     C                   Z-ADD     ZDAYNO        PVDT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C* Else default to run date
     C                   ELSE
     C**********         Z-ADD     AGRDNB        PVDT                                         CSC011
     C                   Z-ADD     WRunday       PVDT                                         CSC011
     C                   ENDIF
 
      * If portfolio management is on
     C                   IF        BGPFMG     = 'Y'
     C                   IF        DDPTFR <> *BLANKS
     C*
     C* Must reference a current Portfolio position and must be greater
     C* than or equal to the date when the position was set up.
     C*
     C                   IF        DDPPRT = 'CT'
     C                   MOVE      'T'           WTVDA
     C                   ELSE
     C                   MOVE      'V'           WTVDA
     C                   ENDIF
     C*
     C** Format Portfolio Reference before chaining PMAPOSPD
     C                   IF         DDPTFR = FCR997 AND
     C                              FCPORS <> 'B'   AND
     C                              BGN4ST <> 'Y' OR
     C                              FCPORS = 'B' AND
     C                              DDPTFR <> *BLANKS AND
     C                              DDPTFR = FCR997 AND
     C                              BGN4ST <> 'Y'
     C                   MOVE      '9997'        WPTFR             4
     C                   ELSE
     C                   MOVE      DDPTFR        WPTFR
     C                   ENDIF
     C*
     C     POSKEY        SETGT     PMAPOSLL
     C                   READP     PMAPOSLL                               99
     C*
     C                   IF        *IN99 OR
     C                             PCNM <> QACNUM OR
     C                             WPTFR <> QAPTFR OR
     C                             DDPSSN <> QATDSS OR
     C                             WTVDA <> QATVDA
 
      * Error 202: Value Date entered is later than the run date
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDPVDT'
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1141'
     C                   EVAL      DDVDTOK   = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
     C     DDVDTOK       IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   RETURN
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
      ** Value Date
     C                   PARM                    DDPVDT            6
      ** Portfolio Reference
     C                   PARM                    DDPTFR            4
      ** Price Type
     C                   PARM                    DDPPRT            2
      ** Security Shortname
     C                   PARM                    DDPSSN           10
      ** Customer Number
     C                   PARM                    DDPCNM           10
      *
      ** ICD
      *
      * portfolio management indicator
     C                   PARM                    BGPFMG            1
      * date format indicator
     C                   PARM                    BJDFIN            1
      * Ref attached to 997
     C                   PARM                    FCR997            4
      * portfolios supported
     C                   PARM                    FCPORS            1
      * private banking
     C                   PARM                    BGN4ST            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXar
     C                   PARM                    MsgDtaXAr
      ** Value Date, numeric
     C                   PARM                    PVDT              5 0
      ** Nominal currency
     C                   PARM                    QATNMC            3
      ** Portfolio currency code
     C                   PARM                    QAPTCY            3
 
      ** Value Date OK flag
     C                   PARM                    DDVDTOK           1
      *
      * IN the dtaarea RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = AGRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        S1SUPP = LIBR                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 1                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
 
      * Access Installation Control Data record fo Securities Trading
      * (Database error handling done in access program).
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
     C     POSKEY        KLIST
     C                   KFLD                    PCNM
     C                   KFLD                    WPTFR
     C                   KFLD                    DDPSSN
     C                   KFLD                    WTVDA             1
     C                   KFLD                    PVDT              5 0
 
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
