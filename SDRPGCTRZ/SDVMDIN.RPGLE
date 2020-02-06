     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Multiply Divide indicator')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Market Data Feed Details Val. *
      *                                                               *
      *  SDVMDIN - Validate Multiply Divide Indicator                 *
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
      *  Prev Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP038             Date 15May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP038 - Conversion of BASE Rates into Modular APIs          *
      *                                                               *
      *****************************************************************
 
 
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
      *
      * Currency codes
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
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
      ** Must be either M or D
     C                   IF        DDMDIN <> 'M' AND DDMDIN <> 'D'
     C                   EVAL      DDMDINOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMDIN    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR4285'
     C                   ENDIF
 
      ** Can spot rate be amended ?
      ** 1- Is currency filled ?
     C                   IF        DDMDINOK = 'Y'
     C                   IF        DDCYCD = *BLANK
     C                   EVAL      DDMDINOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMDIN    '
     C                   EVAL      MsgIdXAr(Idx) = 'SDM0087'
     C                   ENDIF
     C                   ENDIF
 
      ** 2- Can we retrieve details of currency ?
     C                   IF        DDMDINOK = 'Y'
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCYCD        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DDMDINOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMDIN    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR0071'
     C                   ENDIF
     C                   ENDIF
 
      ** Determine whether we can modify this rate
     C                   IF        DDMDINOK = 'Y'
     C                   CALLB     'SDSPTRAEU'                          90
     C                   PARM                    RetCodeIn
     C                   PARM                    DDCYCD
     C                   PARM                    A6INCY
     C                   PARM                    A6TPSD
     C                   PARM                    SprtAmd           1
 
     C                   IF        RetCodeIn <> *BLANK  OR *IN90
     C                   MOVEL     'SDSPTRAEU'   DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     DDCYCD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Can't be changed M or D
     C                   IF        DDMDINOK = 'Y'
     C                   IF        CEU002 = 'Y' AND SprtAmd = 'N'
     C                   IF        DDMDIN <> AVMDIN
     C                   EVAL      DDMDINOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMDIN    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR4286'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
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
      ** Other parms
      *
      ** Current multiply Divide Indicator
     C                   PARM                    DDMDIN
      *
      ** Previous multiply Divide Indicator
     C                   PARM                    AVMDIN
      *
      ** Currency
     C                   PARM                    DDCYCD
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Multiply / Divide OK
     C                   PARM                    DDMDINOK          1
 
      *
     C     *LIKE         DEFINE    A6MDIN        DDMDIN
     C     *LIKE         DEFINE    A6MDIN        AVMDIN
     C     *LIKE         DEFINE    A6CYCD        DDCYCD
      *
      ** Check if switchable feature CEU002 is switched on.
      ** Euro rates
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU002'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU002            1
     C                   ELSE
     C                   MOVE      'N'           CEU002
     C                   ENDIF
 
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
**  CPY@
(c) Finastra International Limited 2001
