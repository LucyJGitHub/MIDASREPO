     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees Database Update')                *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFEUPD - DL Dealing Fees Database Update                  *
      *                                                               *
      *  Function:  This function allows the update of corresponding  *
      *             Dealing Fees record into the Midas database.      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSW208             Date 15Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG9516            Date 09Dec05               *
      *                 CAS011             Date 16Jun05               *
      *                 CAS009  *CREATE    Date 06Jun04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data.    *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9516 - Add ZMUSER processing to retrieve correct user in  *
      *            Insert/Amend/Authorise                             *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      * Midas DL Dealing Fees File
     FDLFEEDL7  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      * Midas DL Dealing FeeS File by Deal/Fee Seq
     FDLFEEDL1  IF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0 : DLFEEDX0)

      * Midas DL Dealing Fees History File
     FDLFHSTL1  IF A E           K DISK    INFSR(*PSSR)

      * Midas DL Dealing Fees Trailer File
     FDLFEEZ    UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSW208
      * Midas DL Sorted Deal Transaction Index                                                CSW208
     FSDTIX     UF A E           K DISK                                                       CSW208
     F                                     COMMIT                                             CSW208
     F                                     PREFIX(DX)                                         CSW208
                                                                                              CSW208
      * Midas DL Sorted Deal Transaction Index                                                CSW208
     FMMDELULL  UF A E           K DISK                                                       CSW208
     F                                     COMMIT                                             CSW208
     F                                     INCLUDE(DEALSDCF)                                  CSW208
     F                                     INCLUDE(DEALSDFF)                                  CSW208
     FMMEIRDL0  UF   E           K DISK                                                       CAS011
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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      **  Table
     D CURR            S              3    DIM(150)                             ALL CCYS
     D TXND            S              1  0 DIM(150)                             Tlx NtcDay/CCY

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      **  Externally Described Data Structure for Valid Deal Fees
     D DLVDLFE       E DS                  EXTNAME(DLVDLFEPD)

      ** Rename fields for Timestamp checking
     D ChkDLFEFmt    E DS                  EXTNAME(DLFEED)
     D                                     PREFIX(CH)

     D DealsDtlC     E DS                  EXTNAME(DEALSDC)
     D                                     PREFIX(C_)

     D DealsDtlD     E DS                  EXTNAME(DEALSDD)
     D                                     PREFIX(D_)

      **  Midas Dealing Fees File
     D DealFee       E DS                  EXTNAME(DLFEED)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Midas Modules details accessed via access program
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
                                                                                              CAS011
     D SDFEE         E DS                  EXTNAME(SDFEEPD)                                   CAS011
      ** External DS for Fee Details                                                          CAS011
                                                                                              CAS011
      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** Midas API Message Header Format Definition
     D APHEAD        E DS                  EXTNAME(APHEADPD)

      * Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** Work file of update to LE position files
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

      ** DS for ZMUSER details                                                               BUG9516
     D ZMUSER          DS            17                                                      BUG9516
     D  PUSRID                 1     10                                                      BUG9516
                                                                                             BUG9516
      ** Fields defined for Enhancement CSC011

     D CSC011          S              1A
     D TRANSDTL        S           5800A
     D PDealNum        S             18A
     D PADealNo        S             18A
     D PTimestamp      S             26A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A

      ** AOFEER0 Parameters                                                                   CAS011
     D PKEY            S              2A                                                      CAS011

      ** Work fields
     D Idx             S              3P 0
     D WKREQI          S             32A
     D WKDITM          S             20A
     D DDACTN          S              1A
     D DDTRID          S             20A
     D DDDLNO          S              6S 0
     D DDFSEQ          S              2S 0
     D DADLNO          S              6A
     D DAFSEQ          S              2A
     D OKACTN          S              1A
     D OKDLNO          S              1A
     D OKFSEQ          S              1A
     D ModeofOp        S              6A
     D RespMode        S              1A
     D WDLNO           S              6S 0
     D WFSEQ           S              2S 0
     D @ALSEQ          S              2A
     D ERR             S              1  0
     D KEYC1           S             10A
     D ZACTN           S                   LIKE(DDACTN)
     D W@SWRI          S                   LIKE(DFSWRI)
     D CSW208          S              1A                                                      CSW208
     D @@CNRQ          S              1A                                                      CSW208
     D @XTIME          S              6S 0                                                    CSW208
GDM  D WADJY           S              1A
GDM  D WUPDEI          S              1A

      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Body                                              *
      *                                                               *
      *****************************************************************
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD

     C     ReturnCode    IFNE      *BLANKS
     C                   RETURN
     C                   END

      **  Get default user from ZMUSER                                                       BUG9516
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG9516
     C                   IN        ZMUSER                                                    BUG9516
     C                   UNLOCK    ZMUSER                                                    BUG9516
     C                   EVAL      PSUser = PUSRID                                           BUG9516
                                                                                             BUG9516
      ** Exit if not Insertion, Amendment, Deletion

     C     DLLCDT        IFNE      'I'
     C     DLLCDT        ANDNE     'A'
     C     DLLCDT        ANDNE     'D'
     C     DLLCDT        ANDNE     'X'
     C                   RETURN
     C                   END

      ** Clear Shadow Post data structures

     C                   CLEAR                   Z#BSTS
     C                   CLEAR                   Z#ASTS

     C                   MOVE      DLFCOD        PKEY                                         CAS011
     C                   CALL      'AOFEER0'                                                  CAS011
     C                   PARM      '*BLANKS'     PRTCD                                        CAS011
     C                   PARM      '*KEY   '     POPTN                                        CAS011
     C                   PARM                    PKEY                                         CAS011
     C     SDFEE         PARM      SDFEE         DSFDY                                        CAS011
                                                                                              CAS011
     C                   EVAL      WADJY = *BLANK                                             CAS011
     C                   IF        PRTCD = *BLANKS                                            CAS011
     C                   EVAL      WADJY = AUADJY                                             CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      ** Insert, Amend, Authorise or Delete Dealing Fee

     C     DLLCDT        CASEQ     'I'           DLFEINS
     C     DLLCDT        CASEQ     'A'           DLFEAMD
     C     DLLCDT        CASEQ     'X'           DLFEAUT
     C     DLLCDT        CASEQ     'D'           DLFEDLT
     C                   END

      *                                                                                       CSW208
      ** Generate Confirmation                                                                CSW208
      ** SWIFT 2008 should be ON                                                              CSW208
      ** Deal and Deal Fee should be authorised                                               CSW208
      *                                                                                       CSW208
     C                   IF        CSW208 = 'Y' AND                                           CSW208
     C                             DFFSTS = 'A'                                               CSW208
      *                                                                                       CSW208
     C                   EXSR      WRTDTX                                                     CSW208
     C                   EXSR      UPDDTH                                                     CSW208
     C                   ENDIF                                                                CSW208
                                                                                              CSW208
     C                   MOVEL     DealFee       Z#ASTS
     C                   EXSR      SRSHDW

      ** If 24x7 Midas Availability is installed
      ** and Support System is active

     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)

     C                   CALLB     'DLDLFELOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DealFee
     C                   PARM                    TRANSDTL

      ** If there is no error, write the log file

     C                   IF        RetCodeOut = *BLANKS

     C                   EVAL      APTGTTYPE = 'DLFEED'
     C                   EVAL      APFOTRANID = DFFRNT
     C                   EVAL      APRPRLOCN  = DFREPA
     C                   EVAL      APUSERID   = PSUser
     C                   EVAL      APMIDUSR   = PSUser

     C                   MOVE      DFDLNO        DADLNO
     C                   MOVE      DFFSEQ        DAFSEQ
     C                   EVAL      PDealNum = DADLNO + DAFSEQ

     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       PTimestamp
     C                   PARM                    PDealNum
     C                   PARM      *BLANKS       PADealNo

     C                   ENDIF

      ** If there is an error in either log file, end program

     C                   IF        RetCodeOut <> *BLANKS
     C                   EVAL      ReturnCode = '*ERROR'
     C                   ENDIF

     C                   ENDIF

      ** Exit Program

     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR

      ** Retrieve current details

     C                   EVAL      ReturnCode = *BLANKS
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)

     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1

      ** Set retrieve mode to blank  (Access using Midas transaction ID).

     C     @Type         IFEQ      '0'
     C                   MOVE      '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVE      *BLANKS       ModeofOp
     C                   END

     C                   IF        DLFSEQ = 0
     C                   EVAL      DAFSEQ = *BLANK
     C                   ELSE
     C                   MOVE      DLFSEQ        DAFSEQ
     C                   ENDIF
     C                   CALLB     'DLDLFERTV'
     C                   PARM                    RetCodeIn
     C                   PARM                    ModeofOp
     C                   PARM      ' '           RespMode
     C                   PARM      DLLCDT        DDACTN
     C                   PARM      DLFRNT        DDTRID
     C                   PARM      DLDLNO        DDDLNO
     C                   PARM                    DAFSEQ
     C                   PARM                    ChkDLFEFmt
     C                   PARM                    OKACTN
     C                   PARM                    OKDLNO
     C                   PARM                    OKFSEQ
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    DealsDtlC
     C                   PARM                    DealsDtlD

      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)

      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original record was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.

      ** Interactive mode:

     C     @TYPE         IFEQ      '1'

     C     CHDFTMST      IFNE      DLTMST
     C                   MOVEL     '*RECUPD'     ReturnCode
     C                   END

      ** Batch mode:
     C                   ELSE
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C     OKFSEQ        OREQ      'N'
     C                   MOVEL     '*RECUPD'     ReturnCode
     C                   Z-ADD     1             C                 2 0

     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       DBError          28
     C                   MOVEL     MsgIDArr(C)   DBError
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   END

     C                   END

     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * DLFEINS - Insert a new Dealing Fee                           *
      *                                                              *
      ****************************************************************
     C     DLFEINS       BEGSR

      ** Initialise Deal Fee

      ** Generate fee sequence no.
     C                   EVAL      WDLNO = DLDLNO
     C                   EXSR      DLFESEQ
     C                   EVAL      WDLNO = DLDLNO
     C                   EVAL      WFSEQ = DFFSEQ
     C                   EVAL      DLFSEQ = DFFSEQ                                             TEDDY

     C                   CLEAR                   DealFee

     C                   MOVEL     DLVDLFE       DealFee

     C                   EVAL      DFDLNO = WDLNO
     C                   EVAL      DFFSEQ = WFSEQ

      ** If CSC011 is installed, supply a Front Office ID for the
      ** transaction even if it originated from SIN module.

     C                   IF        CSC011 = 'Y'
     C                   IF        DFFRNT = *BLANKS
     C                   MOVE      DFDLNO        DADLNO
     C                   MOVE      DFFSEQ        DAFSEQ
     C                   EVAL      DFFRNT = 'MD' + DADLNO + DAFSEQ
     C                   ENDIF
     C                   ENDIF

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
      ** Set SWIFT Message Regeneration Indicator
      *
     C                   EXSR      SRSWRI
      *
     C                   EVAL      DFSWRI = W@SWRI
     C                   EVAL      DFPYON = DLPYON
     C                   EVAL      DFLCDT = DLLCDT
     C                   EVAL      DFLCHD = BJRDNB
     C                   EVAL      DFFSTS = 'C'
     C                   EVAL      DFORED = BJRDNB
     C                   EVAL      DFIUSR = PSUser
     C                   EVAL      DFTMST = TimeStamp

GDM  C                   EXSR      SRUpdEIR                                                   CAS011
GDM  C                   EVAL      DFTFTD = *ZERO
GDM  C                   EVAL      DFAFLS = *ZERO
GDM  C                   EVAL      DFADJY = WADJY
      ** WRITE Deal Fee

     C                   WRITE     DLFEEDD0

      * Update Trailer File
     C                   EXSR      SRTRAL

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * DLFEAMD - Amend a Deal Fee                                   *
      *                                                              *
      ****************************************************************
     C     DLFEAMD       BEGSR

      ** Access Deal Fee

     C                   EVAL      DFDLNO = DLDLNO
     C                   EVAL      DFFSEQ = DLFSEQ
     C     @KDLFE0       CHAIN     DLFEEDL7                           99

      ** Database Error

     C                   IF        *IN99 = '1'
     C                   MOVEL     DFDLNO        DBKEY
     C                   MOVE      DFFSEQ        DBKEY
     C                   EVAL      DBFILE = 'DLFEED  '
     C                   EVAL      DBASE = 1
     C                   EXSR      SRERR
     C                   END
      *                                                                                       CSW208
     C                   IF        CSW208 = 'Y'                                               CSW208
     C                   EXSR      CNFAMD                                                     CSW208
     C                   ENDIF                                                                CSW208
      *
      ** Set SWIFT Message Regeneration Indicator

     C                   EXSR      SRSWRI
GDM
GDM  C                   EVAL      WUPDEI = 'N'
GDM
GDM  C                   IF        WADJY <> DFADJY OR DLFCCY <> DFFCCY
GDM  C                             OR DLFAMT <> DFFAMT
GDM  C                   EVAL      WUPDEI = 'Y'
GDM  C                   ENDIF
GDM
GDM   ** If the Fee is a Bullet Fee or Amortised Fee
GDM
GDM  C                   IF        DFPYON = *BLANKS OR DFPYON = 'S'
GDM
GDM   ** If Start Date has been Amended
GDM
GDM  C                   IF        DLPSTD <> DFPSTD
GDM  C                   EVAL      WUPDEI = 'Y'
GDM  C                   ENDIF
GDM  C                   ENDIF
GDM
GDM   ** The Fee is an Accrued Fee
GDM
GDM  C                   IF        DFPYON = 'E' OR (DFPYON = 'N'
GDM  C                             AND DLFAMT <> 0)
GDM
GDM   ** The End Date has been Amended
GDM
GDM  C                   IF        DLPEND <> DFPEND
GDM  C                   EVAL      WUPDEI = 'Y'
GDM  C                   ENDIF
GDM  C                   ENDIF
GDM
GDM  C                   IF        WUPDEI = 'Y'
GDM  C                   EXSR      SRUpdEIR
GDM  C                   EVAL      DFADJY = WADJY
GDM  C                   ENDIF

     C                   MOVEL     DealFee       Z#BSTS

     C                   MOVEL     DLVDLFE       DealFee

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   EVAL      DFSWRI = W@SWRI
     C                   EVAL      DFFCOD = DLFCOD
     C                   EVAL      DFFCCY = DLFCCY
     C                   EVAL      DFFAMT = DLFAMT
     C                   EVAL      DFPYON = DLPYON
     C                   EVAL      DFPSTD = DLPSTD
     C                   EVAL      DFPEND = DLPEND
     C                   EVAL      DFLCDT = DLLCDT
     C                   EVAL      DFLCHD = BJRDNB
     C                   EVAL      DFAUSR = PSUser
     C                   IF        DFFSTS = 'A' or DFFSTS = 'R'
     C                   EVAL      DFFSTS = 'R'
     C                   ELSE
     C                   EVAL      DFFSTS = 'C'
     C                   END
     C                   EVAL      DFTMST = TimeStamp

      * Update Deal Fee

     C                   UPDATE    DLFEEDD0

      * Update Trailer File
     C                   EXSR      SRTRAL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * DLFEAUT - Authorise a Deal Fee                               *
      *                                                              *
      ****************************************************************
     C     DLFEAUT       BEGSR

      ** Access Deal Fee

     C                   EVAL      DFDLNO = DLDLNO
     C                   EVAL      DFFSEQ = DLFSEQ
     C     @KDLFE0       CHAIN     DLFEEDL7                           99

      ** Database Error

     C                   IF        *IN99 = '1'
     C                   MOVEL     DFDLNO        DBKEY
     C                   MOVE      DFFSEQ        DBKEY
     C                   EVAL      DBFILE = 'DLFEED  '
     C                   EVAL      DBASE = 2
     C                   EXSR      SRERR
     C                   END
      *                                                                                       CSW208
      ** Update confirmation flag if SWIFT 2008 is ON                                         CSW208
      ** and Last change type is Insert                                                       CSW208
      *                                                                                       CSW208
     C                   IF        CSW208 = 'Y' AND                                           CSW208
     C                             DFLCDT = 'I'                                               CSW208
     C                   EXSR      CONF                                                       CSW208
     C                   ENDIF                                                                CSW208
      *
      ** Set SWIFT Message Regeneration Indicator
      *
     C                   EXSR      SRSWRI

     C                   MOVEL     DLVDLFE       DealFee

     C                   EVAL      DFSWRI = W@SWRI
     C                   EVAL      DFLCDT = DLLCDT
     C                   EVAL      DFLCHD = BJRDNB
     C                   EVAL      DFXUSR = PSUser
     C                   EVAL      DFFSTS = 'A'

      * Update Deal Fee

     C                   UPDATE    DLFEEDD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DLFEDLT - Delete a Dealing Fee                                *
      *                                                               *
      *****************************************************************
     C     DLFEDLT       BEGSR

      * Access Deal Fee

     C                   EVAL      DFDLNO = DLDLNO
     C                   EVAL      DFFSEQ = DLFSEQ
     C     @KDLFE0       CHAIN     DLFEEDL7                           99

      ** Database error

     C     *IN99         IFEQ      '1'
     C                   MOVEL     DFDLNO        DBKEY
     C                   MOVE      DFFSEQ        DBKEY
     C                   EVAL      DBFILE = 'DLFEED  '
     C                   EVAL      DBASE = 2
     C                   EXSR      SRERR
     C                   END
      *                                                                                       CSW208
      ** Update confirmation flag if SWIFT 2008 is ON                                         CSW208
      *                                                                                       CSW208
     C                   IF        CSW208 = 'Y'                                               CSW208
     C                   EXSR      CONF                                                       CSW208
     C                   ENDIF                                                                CSW208

      *
      ** Set SWIFT Message Regeneration Indicator
      *
     C                   EXSR      SRSWRI
      *
     C                   MOVEL     DealFee       Z#BSTS
      *
     C                   EVAL      DFSWRI = W@SWRI
     C                   EVAL      DFRECI = 'R'
     C                   EVAL      DFLCDT = DLLCDT
     C                   EVAL      DFLCHD = BJRDNB
     C                   EVAL      DFFSTS = 'A'
     C                   EVAL      DFAUSR = PSUser

 GDM C                   EXSR      SRUpdEIR
      * Delete Deal Fee Logically

     C                   UPDATE    DLFEEDD0

      * Update Trailer File
     C                   EXSR      SRTRAL

     C                   ENDSR
      /EJECT
      ****************************************************************
      *                                                              *
      * SRSWRI  - Set SWIFT Message Regeneration Indicator           *
      *                                                              *
      ****************************************************************

     C     SRSWRI        BEGSR
      *
     C                   MOVE      *BLANK        W@SWRI
      ** Action Code is Insert
      *
     C                   IF        DLLCDT = 'I'
     C                   EVAL      W@SWRI = *BLANK
     C                   ENDIF
      *
      ** Action Code is Delete
      *
     C                   IF        DLLCDT = 'D'
      *
     C                   IF        DFSPTI ='Y'
     C                             OR DFEPTI = 'Y'
     C                   EVAL      W@SWRI = 'R'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Action Code is Amend
      *
     C                   IF        DLLCDT = 'A'  and
     C                             DFSWRI <> 'I' and
     C                             DFSWRI <> 'B' and
     C                             DFSWRI <> 'H'
      *
      ** Set Telex Notice Date
      *
     C                   EXSR      SRTXDT
      *
      ** If the Fee is a Bullet Fee or Amortised Fee
      *
     C                   IF        DFPYON = *BLANK or
     C                             DFPYON = 'S'
     C                   MOVE      'N'           WAMDED            1
      *
      ** The Start Date has been Amended
      *
     C                   IF        DLPSTD <> DFPSTD
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF                                                  DLPSTD <> DFPSTD
      *
      ** The Amount has been Amended
      *
     C                   IF        DLFAMT <> DFFAMT
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF                                                  DLFAMT <> DFFAMT
      *
     C                   IF        DLOSDB <> DFOSDB or
     C                             DLOMDB <> DFOMDB or
     C                             DLRSTM <> DFRSTM or
     C                             DLRONS <> DFRONS or
     C                             DLRIBN <> DFRIBN or
     C                             DLRIBA <> DFRIBA or
     C                             DLROBN <> DFROBN or
     C                             DLROCN <> DFROCN or
     C                             DLPSTM <> DFPSTM or
     C                             DLPONS <> DFPONS or
     C                             DLPIBN <> DFPIBN or
     C                             DLPIBA <> DFPIBA or
     C                             DLPOBN <> DFPOBN or
     C                             DLPOCN <> DFPOCN or
     C                             DLRCRN <> DFRCRN or
     C                             DLRCRA <> DFRCRA or
     C                             DLRVNO <> DFRVNO or
     C                             DLAWBN <> DFAWBN or
     C                             DLAWBA <> DFAWBA or
     C                             DLBENN <> DFBENN or
     C                             DLBENA <> DFBENA or
     C                             DLDTP1 <> DFDTP1 or
     C                             DLDTP2 <> DFDTP2 or
     C                             DLDTP3 <> DFDTP3 or
     C                             DLDTP4 <> DFDTP4 or
     C                             DLDCHG <> DFDCHG or
     C                             DLBTB1 <> DFBTB1 or
     C                             DLBTB2 <> DFBTB2 or
     C                             DLBTB3 <> DFBTB3 or
     C                             DLBTB4 <> DFBTB4 or
     C                             DLBTB5 <> DFBTB5 or
     C                             DLBTB6 <> DFBTB6 or
     C                             DLCVMR <> DFCVMR
      *
     C                   MOVE      'Y'           WAMDED
      *
     C                   ELSE
      *
     C                   IF        CEU003 = 'Y'
     C                   IF        DLSCCY <> DFSCCY or
     C                             DLICCY <> DFICCY
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        WAMDED = 'Y'
     C                   IF        DFPSTD >= BJRDNB
     C                   IF        DFSPTI = 'Y' or
     C                             DLPSTD <= TXDT or
     C                             DFPSTD <= TXDT
     C                   EVAL      W@SWRI = 'A'
     C                   ELSE
     C                   EVAL      W@SWRI = 'B'
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DFPYON = 'E'
     C                   MOVE      'N'           WAMDED
      *
      ** The Start Date has been Amended
      *
     C                   IF        DLPEND <> DFPEND
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF                                                  DLPEND <> DFPEND
      *
      ** The Amount has been Amended
      *
     C                   IF        DLFAMT <> DFFAMT
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF                                                  DLFAMT <> DFFAMT
      *
     C                   IF        DLOSDB <> DFOSDB or
     C                             DLOMDB <> DFOMDB or
     C                             DLRSTM <> DFRSTM or
     C                             DLRONS <> DFRONS or
     C                             DLRIBN <> DFRIBN or
     C                             DLRIBA <> DFRIBA or
     C                             DLROBN <> DFROBN or
     C                             DLROCN <> DFROCN or
     C                             DLPSTM <> DFPSTM or
     C                             DLPONS <> DFPONS or
     C                             DLPIBN <> DFPIBN or
     C                             DLPIBA <> DFPIBA or
     C                             DLPOBN <> DFPOBN or
     C                             DLPOCN <> DFPOCN or
     C                             DLRCRN <> DFRCRN or
     C                             DLRCRA <> DFRCRA or
     C                             DLRVNO <> DFRVNO or
     C                             DLAWBN <> DFAWBN or
     C                             DLAWBA <> DFAWBA or
     C                             DLBENN <> DFBENN or
     C                             DLBENA <> DFBENA or
     C                             DLDTP1 <> DFDTP1 or
     C                             DLDTP2 <> DFDTP2 or
     C                             DLDTP3 <> DFDTP3 or
     C                             DLDTP4 <> DFDTP4 or
     C                             DLDCHG <> DFDCHG or
     C                             DLBTB1 <> DFBTB1 or
     C                             DLBTB2 <> DFBTB2 or
     C                             DLBTB3 <> DFBTB3 or
     C                             DLBTB4 <> DFBTB4 or
     C                             DLBTB5 <> DFBTB5 or
     C                             DLBTB6 <> DFBTB6 or
     C                             DLCVMR <> DFCVMR
     C                   MOVE      'Y'           WAMDED
      *
     C                   ELSE
      *
     C                   IF        CEU003 = 'Y'
     C                   IF        DLSCCY <> DFSCCY or
     C                             DLICCY <> DFICCY
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        WAMDED = 'Y'
     C                   IF        DFPEND >= BJRDNB
     C                   IF        DFEPTI = 'Y' or
     C                             DLPEND <= TXDT or
     C                             DFPEND <= TXDT
     C                   EVAL      W@SWRI = 'A'
     C                   ELSE
     C                   EVAL      W@SWRI = 'B'
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DFPYON = 'N'
      *
      ** The next Payment Date has been Amended
      *
     C                   IF        DLNPYD <> DFNPYD
     C                   IF        DLNPYD <= TXDT or
     C                             DFNPYD <= TXDT
     C                   EVAL      W@SWRI = 'A'
     C                   ELSE
     C                   EVAL      W@SWRI = 'B'
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DLLCDT = 'X'
      *
      ** Action Code is Authorize
      *
     C                   IF        DFSWRI = 'I'
     C                   EVAL      W@SWRI = *BLANK
     C                   ELSE
     C                   IF        DFSWRI = 'B'
     C                   EVAL      W@SWRI = 'A'
     C                   ELSE
     C                   IF        DFSWRI = 'H'
     C                   EVAL      W@SWRI = 'G'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *    SRTXDT - Set Telex Notice Date
      ********************************************************************
      *
     C     SRTXDT        BEGSR
      *
     C                   MOVE      DLFCCY        ZCCY
     C                   Z-ADD     BJRDNB        ZDAYNO
      *
      ** Retrieve the Telex Notice Day for the currency.
     C     DLFCCY        LOOKUP    CURR(Y)                                75
     C                   MOVE      TXND(Y)       ZNRDYS
      *
      ** Method = Telex, Cheque to be sent, CHIPS, SWIFT, or Cheque to
      **          Collected
     C                   IF        DFSTTL = 1 or
     C                             DFSTTL = 2 or
     C                             DFSTTL = 7 or
     C                             DFSTTL = 8 or
     C                             DFSTTL = 12
      *
     C                   MOVEL     DLOURS        WOURST            2
      *
     C                   MOVE      DLFCCY        KCCY
     C                   MOVEL     WOURST        KNONB
     C                   MOVE      *BLANKS       KCNUM
     C                   CALL      'AONOSTR0'    PLIST1
      ** Call Nostro Details Access Object

     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANK        ZLOC
     C                   ELSE
     C                   MOVE      A7NOSN        ZLOC
     C                   ENDIF

     C                   ENDIF

     C                   EXSR      ZFWDT
      ** Calculate Number of days forward
      *
     C                   Z-ADD     ZDYNBR        TXDT              5 0
      ** Set Telex Notice Date
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *    ZFWDT  - Calc Working Days Forward
      ********************************************************************
     C     ZFWDT         BEGSR
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      * SRTRAL  -  Update Dealing Fees Trailer File                   *
      * Called by: SRWRIT, SRUPDT                                     *
      * Calls    : None                                               *
      *****************************************************************
     C     SRTRAL        BEGSR
      *
     C     1             SETLL     DLFEEZ
     C                   READ      DLFEEZ                                 21
      *
     C                   IF        *IN21 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '1'
     C                   EVAL      DBFILE = 'DLFEEZ  '
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        DLLCDT = 'I'
     C                   ADD       1             DFNINT
     C                   ADD       1             DFNORE
     C                   END
      *
     C                   IF        DLLCDT = 'A'
     C                   ADD       1             DFNAMD
     C                   END
      *
     C                   IF        DLLCDT = 'D'
     C                   ADD       1             DFNDEL
     C                   END
      *
     C                   UPDATE    DLFEEZF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * DLFESEQ - Generate Dealing Fee Sequence No.                   *
      *                                                               *
      *****************************************************************
     C     DLFESEQ       BEGSR

     C                   Z-ADD     99            WFSEQ

      **  Prevent pick up of details from previous fee

     C     KEY001        SETGT     DLFEEDX0
     C     KEY002        READPE    DLFEEDX0                               20

     C                   IF        *IN20 = *ON
     C                   MOVE      '01'          DFFSEQ

     C                   ELSE

     C                   IF        WDLNO = DFDLNO
     C                   ADD       1             DFFSEQ

     C                   ELSE

      ** There are no existing fee records with the key fields input so
      ** put original values back in key fields ready for file update
      ** and allocate a fee sequence no. of 01.

     C                   Z-ADD     WDLNO         DFDLNO
     C                   MOVE      '01'          DFFSEQ

     C                   ENDIF
     C                   ENDIF

      ** Having checked the live fees the matured fees need to be
      ** checked in the same way

     C     KEY001        SETGT     DLFHSTD0
     C     KEY002        READPE    DLFHSTD0                               20

     C                   IF        *IN20 = *OFF

     C                   IF        WDLNO = HIDLNO
     C                   ADD       1             HIFSEQ

     C                   ELSE
     C                   MOVE      '01'          HIFSEQ

     C                   ENDIF
     C                   ENDIF

      **  Store allocated sequence number for output

     C                   IF                  DFFSEQ > HIFSEQ
     C                   MOVE      DFFSEQ        @ALSEQ
     C                   ELSE
     C                   MOVE      HIFSEQ        @ALSEQ
     C                   ENDIF
      *
     C                   MOVE      @ALSEQ        DFFSEQ

     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSHDW - Generate Shadow Postings                             *
      *                                                               *
      *****************************************************************
     C     SRSHDW        BEGSR
      *
      ** Do On-line updates
     C     DLLCDT        IFEQ      'I'
     C     DLLCDT        OREQ      'A'
     C     DLLCDT        OREQ      'D'
      *
     C                   MOVE      *BLANKS       ##RTCD
      *
     C                   CALL      'AOOUDFU0'
     C                   PARM                    ##RTCD            7
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
      *
     C     ##RTCD        IFEQ      '*ERROR*'
     C                   EVAL      DBFILE = 'AOOUDFU0'
     C                   EVAL      DBASE = 4
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CAS011
      *****************************************************************                       CAS011
      *                                                               *                       CAS011
      * SRUpdEIR  - Subroutine to update EIR info                     *                       CAS011
      *                                                               *                       CAS011
      *****************************************************************                       CAS011
     C     SRUpdEIR      BEGSR                                                                CAS011
                                                                                              CAS011
     C                   IF        WADJY = 'Y'                                                CAS011
                                                                                              CAS011
     C     DLDLNO        CHAIN     MMEIRDL0                                                   CAS011
     C                   IF        %FOUND(MMEIRDL0) and DLPSTD <= EIENDT                      CAS011
     C                   EVAL      EIRCAL = 'Y'                                               CAS011
     C                   UPDATE    MMEIRDD0                                                   CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDSR                                                                CAS011
      ********************************************************************                    CAS011
      /EJECT
     C****************************************************************                        CSW208
     C*                                                              *                        CSW208
     C* CONF - SET CONFIRMATION INDICATOR ON INSERTION               *                        CSW208
     C*                                                              *                        CSW208
     C****************************************************************                        CSW208
     C     CONF          BEGSR                                                                CSW208
      *                                                                                       CSW208
      ** CONFIRMATION REQUIRED IF SETTLEMENT INSTRUCTIONS PRESENT                             CSW208
      *                                                                                       CSW208
     C     C_RSTM        IFNE      *ZERO                                                      CSW208
     C     C_PSTM        ORNE      *ZERO                                                      CSW208
      *                                                                                       CSW208
     C     DLDLNO        CHAIN     DEALSDCF                           99                      CSW208
      *                                                                                       CSW208
     C     *IN99         IFEQ      *OFF                                                       CSW208
     C                   BITOFF    '0'           CNFI                                         CSW208
     C                   UPDATE    DEALSDCF                                                   CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   ENDSR                                                                CSW208
     C****************************************************************                        CSW208
      /EJECT                                                                                  CSW208
     C****************************************************************                        CSW208
     C*                                                              *                        CSW208
     C* CNFAMD - SET CONFIRMATION INDICATOR ON AMENDMENT             *                        CSW208
     C*                                                              *                        CSW208
     C****************************************************************                        CSW208
     C     CNFAMD        BEGSR                                                                CSW208
      *                                                                                       CSW208
      ** IF SETTLEMENT INSTRUCTIONS WERE PREVIOUSLY PRESENT                                   CSW208
      *                                                                                       CSW208
     C     C_RSTM        IFNE      *ZERO                                                      CSW208
     C     C_PSTM        ORNE      *ZERO                                                      CSW208
      *                                                                                       CSW208
      ** If settlement instruction fields have changed                                        CSW208
      *                                                                                       CSW208
     C     DLRSTM        IFNE      DFRSTM                                                     CSW208
     C     DLRONS        ORNE      DFRONS                                                     CSW208
     C     DLRIBN        ORNE      DFRIBN                                                     CSW208
     C     DLRIBA        ORNE      DFRIBA                                                     CSW208
     C     DLROBN        ORNE      DFROBN                                                     CSW208
     C     DLPSTM        ORNE      DFPSTM                                                     CSW208
     C     DLPONS        ORNE      DFPONS                                                     CSW208
     C     DLPIBN        ORNE      DFPIBN                                                     CSW208
     C     DLPIBA        ORNE      DFPIBA                                                     CSW208
     C     DLPOBN        ORNE      DFPOBN                                                     CSW208
     C     DLRVNO        ORNE      DFRVNO                                                     CSW208
     C     DLAWBN        ORNE      DFAWBN                                                     CSW208
     C     DLAWBA        ORNE      DFAWBA                                                     CSW208
     C     DLBENN        ORNE      DFBENN                                                     CSW208
     C     DLBENA        ORNE      DFBENA                                                     CSW208
      *                                                                                       CSW208
     C     DFDLNO        CHAIN     DEALSDCF                           99                      CSW208
      *                                                                                       CSW208
     C     *IN99         IFEQ      *OFF                                                       CSW208
     C                   BITOFF    '0'           CNFI                                         CSW208
     C                   UPDATE    DEALSDCF                                                   CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   ENDIF                                                                CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   ENDSR                                                                CSW208
     C****************************************************************                        CSW208
      /EJECT                                                                                  CSW208
     C****************************************************************                        CSW208
     C*                                                              *                        CSW208
     C* WRTDTX - WRITE A DTRIX RECORD                                *                        CSW208
     C*                                                              *                        CSW208
     C****************************************************************                        CSW208
     C     WRTDTX        BEGSR                                                                CSW208
      *                                                                                       CSW208
      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD                                       CSW208
      *                                                                                       CSW208
     C                   EVAL      @@CNRQ = 'N'                                               CSW208
     C     DLDLNO        CHAIN     DEALSDCF                           99                      CSW208
      *                                                                                       CSW208
     C     *IN99         IFEQ      *OFF                                                       CSW208
     C                   TESTB     '0'           CNFI                     99                  CSW208
     C     *IN99         IFEQ      *OFF                                                       CSW208
     C                   EVAL      @@CNRQ = 'Y'                                               CSW208
     C                   ENDIF                                                                CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   MOVE      'D'           DXRECI                                       CSW208
     C                   MOVE      'D'           DXRCDT                                       CSW208
     C                   Z-ADD     DFDLNO        DXDLNO                                       CSW208
     C                   Z-ADD     DFPSTD        DXVDAT                                       CSW208
     C                   Z-ADD     DFFSEQ        DXDASN                                       CSW208
     C                   MOVE      DFLCDT        DXCHTP                                       CSW208
     C                   MOVE      @@CNRQ        DXCNRQ                                       CSW208
     C                   MOVE      'N'           DXCNPR                                       CSW208
     C                   MOVE      ' '           DXREPR                                       CSW208
     C                   TIME                    @XTIME                                       CSW208
     C                   MOVEL     @XTIME        DXTIM                                        CSW208
     C                   MOVEL     'N'           DXPRI1                                       CSW208
     C                   MOVEL     'N'           DXPRI2                                       CSW208
     C                   MOVEL     'N'           DXPRI3                                       CSW208
     C                   Z-ADD     0             DXICIN                                       CSW208
     C                   MOVEL     DFBRCA        DXBRCA                                       CSW208
     C                   Z-ADD     *ZERO         DXTNLU                                       CSW208
      *                                                                                       CSW208
     C                   WRITE     DTRIXDF                                                    CSW208
      *                                                                                       CSW208
     C                   ENDSR                                                                CSW208
     C****************************************************************                        CSW208
      /EJECT                                                                                  CSW208
     C****************************************************************                        CSW208
     C*                                                              *                        CSW208
     C* UPDDTH - UPDATE THE DTRIX HEADER RECORD                      *                        CSW208
     C*                                                              *                        CSW208
     C****************************************************************                        CSW208
     C     UPDDTH        BEGSR                                                                CSW208
      *                                                                                       CSW208
      ** Access the header record                                                             CSW208
      *                                                                                       CSW208
     C                   Z-ADD     *ZERO         DXDLNO                                       CSW208
     C     DXDLNO        CHAIN     DTRIXHF                            99                      CSW208
      *                                                                                       CSW208
      ** DATABASE ERROR                                                                       CSW208
      *                                                                                       CSW208
     C     *IN99         IFEQ      *ON                                                        CSW208
     C                   MOVEL     DXDLNO        DBKEY                                        CSW208
     C                   MOVEL     'DTRIXHF '    DBFILE                                       CSW208
     C                   MOVEL     8             DBASE                                        CSW208
     C                   EXSR      SRERR                                                      CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
      ** Add 1 to number of deal records (on DTRIXDD)                                         CSW208
      *                                                                                       CSW208
     C                   ADD       1             DXNDLR                                       CSW208
      *                                                                                       CSW208
     C                   UPDATE    DTRIXHF                                                    CSW208
      *                                                                                       CSW208
     C                   ENDSR                                                                CSW208
     C****************************************************************                        CSW208
      /EJECT                                                                                  CSW208
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

      **  Program Parameters

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    DLVDLFE

      ** Set up parameter fields
      ** PLIST for access program AONOSTR0
     C     PLIST1        PLIST
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    KCNUM             6
     C                   PARM                    KCCY              3
     C                   PARM                    KEYC1
     C                   PARM                    KEYD              2
     C                   PARM                    KNONB             2
     C                   PARM                    KEYF              3
     C                   PARM                    KEYG             10
     C                   PARM                    KEYH              1
     C     SDNOST        PARM      SDNOST        DSFDY

      * Key list to chain Dealing Fee file DLFEEDL1
     C     @KDLFE0       KLIST
     C                   KFLD                    DFDLNO
     C                   KFLD                    DFFSEQ

      ** Key list for accessing Market Data Feed Requested Items Details

     C     KLMDFI        KLIST
     C                   KFLD                    WKREQI
     C                   KFLD                    WKDITM

      ** Key list for accessing last Fee Sequence 1

     C     KEY001        KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WFSEQ

      ** Key list for accessing last Fee Sequence 2

     C     KEY002        KLIST
     C                   KFLD                    WDLNO

      ** Access Bank details via access program
      ** (database error handling done in access program)

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 5
     C                   EXSR      *PSSR
     C                   END

      ** Access Module Details

     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

      * Database error

     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 6
     C                   EXSR      *PSSR
     C                   END

      *
      ** Read in information for dealing currencies.
      ** Store in array
      *
     C                   Z-ADD     1             Y                 3 0
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C                   PARM                    PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   MOVE      A6CYCD        CURR(Y)
     C                   MOVE      A6TXND        TXND(Y)                        Telex Noti.
      *
     C                   DOW       PRTCD <> '*EOF    '
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*NEXT  '     POPTN
     C                   PARM                    PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRTCD <> '*EOF    '
     C                             and A6DLCI = 'Y'
      *
     C                   ADD       1             Y
      *
     C                   MOVE      A6CYCD        CURR(Y)
     C                   MOVE      A6TXND        TXND(Y)                        Telex Noti.
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Check if CSC011 is installed

     C                   EVAL      CSC011 = 'N'

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 7
     C                   EXSR      SRERR
     C                   ENDIF

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF

      ** Determine if CEU003 is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      'CEU003'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU003            1
     C                   ELSE
     C                   MOVE      'N'           CEU003
     C                   ENDIF
      *                                                                                       CSW208
      ** Determine if CSW208 is installed                                                     CSW208
      *                                                                                       CSW208
     C                   MOVEL     'N'           CSW208                                       CSW208
     C                   CALL      'SWIF2008'                                                 CSW208
     C                   PARM      *BLANKS       PRTCD                                        CSW208
                                                                                              CSW208
     C                   IF        PRTCD = 'CSW2008'                                          CSW208
     C                   MOVEL     'Y'           CSW208                                       CSW208
     C                   ENDIF                                                                CSW208

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRERR - EXCEPTION ERRORS                                     *
      *                                                              *
      ****************************************************************
     C     SRERR         BEGSR

     C                   MOVEL     '*ERROR '     ReturnCode
     C                   MOVEL     'DLDLFEUPD'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP

      **  Terminate the program

     C                   RETURN
      *
     C                   ENDSR
     C****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
**  CPY@
(c) Finastra International Limited 2004
