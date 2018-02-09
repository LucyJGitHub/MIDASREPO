     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade transaction profit centre')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  SEVTTPRFCN - Validate Trade Transaction profit centre        *
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
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD009             Date 10Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 167953             Date 27Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 14Jan98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  167953 - Correct Profit Centre defaulting                    *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSEPCCD    IF   E           K DISK
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
 
      ** Portfolio details data structure used by called program within module
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      * Client Details data structure                                                         167953
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  167953
 
      ** Dummy data field used by called program within module
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs, long data structure                                   167953
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     167953
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Customer
     D*TCNR*****       S              6S 0                                                    CSD027
     D TCNR            S              6A                                                      CSD027
 
     ** Working variables
     ** -----------------
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
     D @KEY1           S             10A                                                      167953
     D @KYST           S              7A                                                      167953
 
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
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** Clear output trade fields
 
     C                   MOVEL     *BLANK        TPRC
      *
      ** DEFAULT
      *
     C     Default       IFEQ      'Y'
     C     DDTPRC        ANDEQ     *BLANK
     C                   EXSR      TPRCD
     C                   END
      *
      ** Validate
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      TPRCV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDTPRCOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      * Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TPRCV - Validation routine for Transaction Profit Centre      *
      *                                                               *
      *****************************************************************
     C     TPRCV         BEGSR
      *
      ** If trade is being done with a portfolio customer
      *
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
 
      ** Get the current customer position profit centre record
 
     C                   MOVE      TCNR          CNUM
     C                   MOVE      DDBRCD        BRCA
     C                   MOVE      DDSESN        SESN
 
     C     KLSPCC        CHAIN     SEPCCD                             44
      *
      ** If a customer position profit centre record exists and the
      ** profit centre entered is not what is on this record,
      ** overwrite it and send a warning message
      *
     C     *IN44         IFEQ      '0'
     C     DDTPRC        ANDNE     PCCU
     C                   MOVE      PCCU          DDTPRC
     C                   ADD       1             WIx
     C                   MOVEL     'MMA0526'     WMsgidXAr(WIx)
     C                   MOVEL     'DDTPRC'      WFldNmXAr(WIx)
     C                   MOVE      'W'           DDTPRCOk
     C                   END
      *
      ** Transaction profit centre is required
      *
     C     DDTPRC        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTPRC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0524'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDTPRCOk
      *
      ** Transaction profit centre must be a valid profit centre
      *
     C                   ELSE
      *
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDTPRC        @PCCD             4
     C     SDPRFC        PARM      SDPRFC        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTPRC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0525'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDTPRCOk
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Trade is not being done with a portfolio customer so
      ** trans. profit centre is defaulted to book profit centre
      *
     C                   ELSE
     C                   MOVE      DDBPRC        DDTPRC
     C                   ENDIF
      *
      * Update trade
      *
     C                   MOVE      DDTPRC        TPRC
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** DEFAULT
      *****************************************************************
     C     TPRCD         BEGSR
      *
      ** Default from current customer position profit centre record
      ** if found & protect on screen
      *
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
 
     C                   MOVE      TCNR          CNUM
     C                   MOVE      DDBRCD        BRCA
     C                   MOVE      DDSESN        SESN
 
     C     KLSPCC        CHAIN     SEPCCD                             44
     C     *IN44         IFEQ      '0'
     C                   MOVE      PCCU          DDTPRC
      *
      ** Else default from matrix
      *
     C                   ELSE
     C     BKPCDU        IFEQ      'Y'
     C                   EXSR      AOPRFM
     C     #RTCD         IFEQ      '0'
     C                   MOVE      @PRFC         DDTPRC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Trade is not being done with a portfolio customer so
      ** trans. profit centre is defaulted to book profit centre
      *
     C                   ELSE
     C                   MOVE      DDBPRC        DDTPRC
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AOPRFM - Profit Centre Matrix Access                          *
      *****************************************************************
     C     AOPRFM        BEGSR
      *                                                                                       167953
      ** Get account officer for matrix defaulting                                            167953
      *                                                                                       167953
     C                   MOVEL     TCNR          @KEY1                                        167953
     C                   CALLB     'AOCUSTR0'                                                 167953
     C                   PARM      *BLANKS       @RTCD                                        167953
     C                   PARM      '*KEY   '     @OPTN                                        167953
     C                   PARM                    @KEY1                                        167953
     C                   PARM      *BLANKS       @KYST                                        167953
     C     SDCUST        PARM      SDCUST        DSSDY                                        167953
                                                                                              167953
     C                   MOVE      *BLANKS       @ACOC                                        167953
     C     @RTCD         IFEQ      *BLANKS                                                    167953
     C                   MOVEL     BBACOC        @ACOC                                        167953
     C                   ENDIF                                                                167953
 
     C                   MOVEL     DDTDTP        @TRTY
     C                   MOVEL     TCNR          @CUST
 
     C                   CALLB     'AOPRFMR0'
     C                   PARM      *BLANKS       #RTCD             1
     C                   PARM      DDBPBK        @BKCD             2
     C                   PARM                    @TRTY             5
     C                   PARM      DDTSUB        @SBTY             2
     C                   PARM      DDBRCD        @BRCD             3
     C                   PARM      *BLANKS       @DPCD             3
     C                   PARM      PSUser        @USID            10
     C*******************PARM      *BLANKS       @ACOC             2                          167953
     C                   PARM                    @ACOC             2                          167953
     C                   PARM                    @CUST             6
     C                   PARM                    @PRFC             4
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
 
      ** Transaction profit centre
     C                   PARM                    DDTPRC            4
 
      ** Security
      ** Trade Type
      ** Branch Code
      ** Book
      ** Book Profit Centre
      ** Trade Sub Type
 
     C                   PARM                    DDSESN           10
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDBPBK            2
     C                   PARM                    DDBPRC            4
     C                   PARM                    DDTSUB            2
 
      ** Customer (6S 0)
      ** Customer Classification   (1A)
 
     C                   PARM                    TCNR
     C                   PARM                    CustClass         1
      *
      ** ICD
     C                   PARM                    BKPCDU            1
 
      * OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Profit Ok Indicator
     C                   PARM                    DDTPRCok          1
      *
      ** Transaction Profit Centre
     C                   PARM                    TPRC              4
      *
      ** Key list for SEPCCD
      *
     C     KLSPCC        KLIST                                                                 S0111
     C                   KFLD                    CNUM                                          S0111
     C                   KFLD                    BRCA                                          S0111
     C                   KFLD                    SESN                                          S0111
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
