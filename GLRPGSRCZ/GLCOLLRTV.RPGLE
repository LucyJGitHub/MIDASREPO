     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Details Retrieve')                 *
/*OVR *  OVRDBF FILE(GLCOLLX1) TOFILE(GLCOLLL1) SHARE(*NO)            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLLRTV - Collateral Details Retrieve                      *
      *                                                               *
      *  Function: This module will retrieve a Collateral item from   *
      *            the database.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 07May13               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG6979            Date 04May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL018             Date 26Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL018 - Risk Weighted Assets                                *
      *  CGL011 - Collateral Processing for Midas (Phase 1)           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Collateral Details by Front Office Id
     FGLCOLLL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Collateral Details by Collateral Reference
     FGLCOLLX1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:GLCOLLD1)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External DS For SAR Details                                                          CGL018
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL018
      *
      ** Collateral Definition Details
     D CrCoFilFmt    E DS                  EXTNAME(GLCOLLPD)
      *
      ** Midas User Data Area
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Externally described DS for Company Details
     D SDCOMP        E DS                  EXTNAME(SDCOMPPD)
      *
      ** Externally described DS for Collateral Details
     D SDCOTP        E DS                  EXTNAME(SDCOTPPD)
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Programs
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message IDs
     D IX              S              3P 0
      *
      ** Parameter for ZALIGN
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   EXSR      SRINIT
      *
     C     ModeOp        IFEQ      '*FRONT'
     C                   EXSR      SRVALFRNT
     C                   ENDIF
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCREFOK      OREQ      'N'
     C                   RETURN
     C                   ENDIF
      *
     C                   EXSR      SRPRIMVAL
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCREFOK      OREQ      'N'
     C                   RETURN
     C                   ENDIF
      *
     C     DDACTN        CASEQ     'I'           SRVALINS
     C     DDACTN        CASEQ     'A'           SRVALAMD
     C     DDACTN        CASEQ     'G'           SRVALAMD
     C     DDACTN        CASEQ     'N'           SRVALAMD
     C     DDACTN        CASEQ     'Z'           SRVALAMD                       CGL018
     C     DDACTN        CASEQ     'D'           SRVALDEL
     C     DDACTN        CASEQ     'E'           SRVALENQ
     C     DDACTN        CASEQ     'X'           SRVALAUT
     C                   CAS                     SRVALREV
     C                   ENDCS
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCREFOK      OREQ      'N'
     C     DDREVFOK      OREQ      'N'
     C     DDREQROK      OREQ      'N'
     C     DDSENTOK      OREQ      'N'
     C     DDSCMPOK      OREQ      'N'
     C     DDSBRCOK      OREQ      'N'
     C     DDSCOLOK      OREQ      'N'
     C     DDSCNUOK      OREQ      'N'
     C     DDSCCYOK      OREQ      'N'
     C     DDSVALOK      OREQ      'N'
     C     DDSGNSOK      OREQ      'N'
     C                   RETURN
     C                   ENDIF
      *
     C     RespMode      IFEQ      'S'
     C                   EXSR      SRAUTHVAL
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation processing                           *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *                                                                                      BUG6979
      ** Lock in data area, ZMUSER, to access the default branch.                            BUG6979
      *                                                                                      BUG6979
     C     *LOCK         IN        ZMUSER                                                    BUG6979
     C                   UNLOCK    ZMUSER                                                    BUG6979
      *                                                                                      BUG6979
      ** Save Default Branch                                                                 BUG6979
      *                                                                                      BUG6979
     C                   MOVE      DBRN          WWDBRN            3                         BUG6979
      *                                                                                      BUG6979
      ** Store Job User                                                                      BUG6979
      *                                                                                      BUG6979
     C                   MOVEL     PSUser        WWUSER           10                         BUG6979
      *
     C                   CLEAR                   CrCoFilFmt
     C                   MOVE      'Y'           DDACTNOK
     C                   MOVE      'Y'           DDCREFOK
     C                   MOVE      'Y'           DDREVFOK
     C                   MOVE      'Y'           DDREQROK
     C                   MOVE      'Y'           DDSENTOK
     C                   MOVE      'Y'           DDSCMPOK
     C                   MOVE      'Y'           DDSBRCOK
     C                   MOVE      'Y'           DDSCOLOK
     C                   MOVE      'Y'           DDSCNUOK
     C                   MOVE      'Y'           DDSCCYOK
     C                   MOVE      'Y'           DDSVALOK
     C                   MOVE      'Y'           DDSGNSOK
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALFRNT - Front Office Validation processing               *
      *                                                               *
      *****************************************************************
     C     SRVALFRNT     BEGSR
      *
      ** Error if action code is not 'I','A',or 'D'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ORNE      'A'
     C     DDACTN        ORNE      'D'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0111'     MsgIdArr(Ix)
     C                   GOTO      EValFrnt
     C                   ENDIF
      *
      ** Error if Front Office transaction Id is blank
      *
     C     FOTRID        IFEQ      *BLANKS
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
     C                   GOTO      EValFrnt
     C                   ENDIF
      *
      ** Access Collateral with Front Office Transaction Id
      *
     C     FOTRID        CHAIN     GLCOLLL0                           99
      *
      ** If Insert
      *
     C     DDACTN        IFEQ      'I'
      *
      ** Front Office Transaction Id can't be present already
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0102'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EValFrnt
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If not insert, Front Office Transaction Id must be present
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDCREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCREF'      FldNameArr(Ix)
     C                   MOVEL     'APM0103'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EValFrnt
     C                   ENDIF
      *
      ** If not insert, update Midas Collateral Reference
      *
     C                   MOVEL     CDCREF        DDCREF
      *
     C                   ENDIF
      *
     C     EValFrnt      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRIMVAL - Primary Validation processing                    *
      *                                                               *
      *****************************************************************
     C     SRPRIMVAL     BEGSR
      *
     C     DDACTN        IFNE      *Blank
      *
     C     DDACTN        IFEQ      'X'
     C     CGL012        ANDNE     'Y'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'COL0002'     MsgIdArr(Ix)
     C                   GOTO      EPrimVal
     C                   ENDIF
      *
      ** If Midas-Risk Weighted Assets Feature Is Switched On,                                CGL018
      ** New Action Code Is To Be Allowed.                                                    CGL018
      *                                                                                       CGL018
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C                   IF        (DDACTN <> 'I') AND (DDACTN <> 'A') AND                    CGL018
     C                             (DDACTN <> 'D') AND (DDACTN <> 'E') AND                    CGL018
     C                             (DDACTN <> 'G') AND (DDACTN <> 'N') AND                    CGL018
     C                             (DDACTN <> 'X') AND (DDACTN <> 'Z')                        CGL018
     C                   MOVE      'N'           DDACTNOK                                     CGL018
     C                   ADD       1             Ix                                           CGL018
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CGL018
     C                   MOVEL     'COL0129'     MsgIdArr(Ix)                                 CGL018
     C                   GOTO      EPrimVal                                                   CGL018
     C                   ENDIF                                                                CGL018
     C                   ELSE                                                                 CGL018
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'G'
     C     DDACTN        ANDNE     'N'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'COL0003'     MsgIdArr(Ix)
     C                   GOTO      EPrimVal
     C                   ENDIF
      *                                                                                       CGL018
     C                   ENDIF                                                                CGL018
      *
     C     DDCREF        IFEQ      *Blanks
      *
     C     DDACTN        IFNE      'I'
     C                   MOVE      'N'           DDCREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCREF'      FldNameArr(Ix)
     C                   MOVEL     'COL0004'     MsgIdArr(Ix)
     C                   GOTO      EPrimVal
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           DDCREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCREF'      FldNameArr(Ix)
     C                   MOVEL     'COL0005'     MsgIdArr(Ix)
     C                   GOTO      EPrimVal
     C                   ENDIF
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     10            ZADIG
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZAlignOk
     C                   PARM      DDCREF        ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZAlignOk      IFNE      'Y'
     C     ZFIELD        OREQ      *Zeros
     C                   MOVE      'N'           DDCREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCREF'      FldNameArr(Ix)
     C                   MOVEL     'COL0006'     MsgIdArr(Ix)
     C                   GOTO      EPrimVal
     C                   ENDIF
      *
     C                   MOVE      DDCREF        CDCREF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDCREF        IFNE      *Blanks
     C                   MOVE      'N'           DDCREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCREF'      FldNameArr(Ix)
     C                   MOVEL     'COL0007'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C     EPrimVal      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALINS - Validation processing for Insert                  *
      *                                                               *
      *****************************************************************
     C     SRVALINS      BEGSR
      *
      ** No additional validation required. Collateral Reference must
      ** always be blank at this point, so there is no need to check
      ** for existence.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALAMD - Validation processing for Amend                   *
      *                                                               *
      *****************************************************************
     C     SRVALAMD      BEGSR
      *
     C                   MOVE      *Blank        CDRECI
     C                   MOVE      *Blank        CDGNSP
      *
     C     DDCREF        CHAIN     GLCOLLX1                           99
      *
      ** If record not found...
     C     *IN99         IFEQ      *ON
     C     CDRECI        ORNE      'D'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'COL0008'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** If record found...
     C     *IN99         IFEQ      *OFF
     C     DDACTN        ANDEQ     'G'
     C     CDGNSP        ANDNE     'G'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'COL0009'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALDEL - Validation processing for Delete                  *
      *                                                               *
      *****************************************************************
     C     SRVALDEL      BEGSR
      *
     C                   MOVE      *Blank        CDRECI
      *
     C     DDCREF        CHAIN     GLCOLLX1                           99
      *
      ** If record not found...
     C     *IN99         IFEQ      *ON
     C     CDRECI        ORNE      'D'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'COL0010'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALENQ - Validation processing for Enquiry                 *
      *                                                               *
      *****************************************************************
     C     SRVALENQ      BEGSR
      *
     C     DDCREF        CHAIN     GLCOLLX1                           99
      *
      ** If record not found...
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'COL0011'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALAUT - Validation processing for Authorisation           *
      *                                                               *
      *****************************************************************
     C     SRVALAUT      BEGSR
      *
     C                   MOVE      *Blank        CDRECI
     C                   MOVE      *Blank        CDAUTH
     C                   MOVE      *Blank        CDIUSR
     C                   MOVE      *Blank        CDAUSR
      *
     C     DDCREF        CHAIN     GLCOLLX1                           99
      *
      ** If record not found...
     C     *IN99         IFEQ      *ON
     C     CDRECI        ORNE      'D'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'COL0012'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** If already authorised...
     C     CDAUTH        IFEQ      'A'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'COL0013'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** Error if authorising user is the same as the
      ** inserting/amending user.
     C     CDIUSR        IFEQ      WWUSER
     C     CDAUSR        OREQ      WWUSER
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'COL0014'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALREV - Validation processing for Review/Select options   *
      *                                                               *
      *****************************************************************
     C     SRVALREV      BEGSR
      *
      ** Validate Review From Collateral Reference
     C     DDREVF        IFNE      *BLANKS
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     10            ZADIG
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZAlignOk
     C                   PARM      DDREVF        ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZAlignOk      IFNE      'Y'
     C     ZFIELD        OREQ      *Zeros
     C                   MOVE      'N'           DDREVFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDREVF'      FldNameArr(Ix)
     C                   MOVEL     'COL0015'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        DDREVF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Requiring Authorisation
     C     DDREQR        IFNE      *Blank
     C     DDREQR        ANDNE     'Y'
     C                   MOVE      'N'           DDREQROK
     C                   ADD       1             Ix
     C                   MOVEL     'DDREQR'      FldNameArr(Ix)
     C                   MOVEL     'COL0016'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** Validate Select Entity Level
     C     DDSENT        IFNE      *Blank
     C     DDSENT        ANDNE     'K'
     C     DDSENT        ANDNE     'C'
     C     DDSENT        ANDNE     'B'
     C                   MOVE      'N'           DDSENTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSENT'      FldNameArr(Ix)
     C                   MOVEL     'COL0017'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** Validate Select Company
     C     DDSCMP        IFNE      *Blanks
     C     DDSENT        IFNE      'C'
      *
     C                   MOVE      'N'           DDSCMPOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSCMP'      FldNameArr(Ix)
     C                   MOVEL     'COL0018'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   CALL      'AOCOMPR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSCMP        PCOMP             3
     C     SDCOMP        PARM      SDCOMP        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDSCMPOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSCMP'      FldNameArr(Ix)
     C                   MOVEL     'COL0019'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     APCMCD        DDSCMP
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Select Branch
     C     DDSBRC        IFNE      *Blanks
     C     DDSENT        IFNE      'B'
      *
     C                   MOVE      'N'           DDSBRCOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSBRC'      FldNameArr(Ix)
     C                   MOVEL     'COL0020'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSBRC        PBRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDSBRCOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSBRC'      FldNameArr(Ix)
     C                   MOVEL     'COL0021'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     A8BRCD        DDSBRC
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Select Collateral Type
     C     DDSCOL        IFNE      *Blanks
      *
     C                   CALL      'AOCOTPR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSCOL        PCOTP             5
     C     SDCOTP        PARM      SDCOTP        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDSCOLOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSCOL'      FldNameArr(Ix)
     C                   MOVEL     'COL0022'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     CTCOLT        DDSCOL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Select Collateral Customer
     C     DDSCNU        IFNE      *Blanks
      *
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSCNU        PKEY1            10
     C                   PARM      *Blanks       PKYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDSCNUOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSCNU'      FldNameArr(Ix)
     C                   MOVEL     'COL0023'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     *BLANKS       DDSCNU
     C                   MOVEL     BBCUST        DDSCNU
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Select Collateral Currency
     C     DDSCCY        IFNE      *Blanks
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSCCY        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDSCCYOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSCCY'      FldNameArr(Ix)
     C                   MOVEL     'COL0024'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     A6CYCD        DDSCCY
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Select Collateral Value
     C     DDSVAL        IFNE      *Blanks
      *
     C     DDSCCY        IFNE      *Blanks
     C                   Z-ADD     A6NBDP        ZADEC
     C                   ELSE
     C                   Z-ADD     2             ZADEC
     C                   ENDIF
      *
     C                   EVAL      ZADIG = 15 - ZADEC
     C                   MOVEL     *Blanks       ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZAlignOk
     C                   PARM      DDSVAL        ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZAlignOk      IFNE      'Y'
     C     ZFIELD        OREQ      *Zeros
     C                   MOVE      'N'           DDSVALOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSVAL'      FldNameArr(Ix)
     C                   MOVEL     'COL0025'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Select General/Specific Indicator
     C     DDSGNS        IFNE      *Blank
     C     DDSGNS        ANDNE     'G'
     C     DDSGNS        ANDNE     'S'
     C                   MOVE      'N'           DDSGNSOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSGNS'      FldNameArr(Ix)
     C                   MOVEL     'COL0026'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUTHVAL - Authority Validation processing                  *
      *                                                               *
      *****************************************************************
     C     SRAUTHVAL     BEGSR
      *
      ** If single branching
     C     BJSBRC        IFNE      *BLANK
      *
      ** Check user's authority for the action.
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ERR               1 0
      *
      **  If action invalid for user
     C     ERR           IFNE      0
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0385'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      ** If multibranching
     C     BJSBRC        IFEQ      *BLANK
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      *BLANK
     C     CDBRCA        OREQ      *BLANK
     C                   MOVE      WWDBRN        ZBR
     C                   ELSE
     C                   MOVE      CDBRCA        ZBR
     C                   ENDIF
      *
      **  Check user's authority for the action & Booking Branch.
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ZBR               3
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
     C     ERR           IFEQ      2
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'N'           DDACTNOK
     C                   ELSE
     C                   MOVEL     'N'           DDCREFOK
     C                   ENDIF
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0386'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     ERR           IFEQ      1
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'N'           DDACTNOK
     C                   ELSE
     C                   MOVEL     'N'           DDCREFOK
     C                   ENDIF
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0387'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS:
      *
      ** Initial screen fields
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCREF           10
     C                   PARM                    DDREVF           10
     C                   PARM                    DDREQR            1
     C                   PARM                    DDSENT            1
     C                   PARM                    DDSCMP            3
     C                   PARM                    DDSBRC            3
     C                   PARM                    DDSCOL            5
     C                   PARM                    DDSCNU           10
     C                   PARM                    DDSCCY            3
     C                   PARM                    DDSVAL           16
     C                   PARM                    DDSGNS            1
      *
     C                   PARM                    CGL012            1
      *
      ** Mode of operation
     C                   PARM                    ModeOp            6
      *
      ** Response Mode
     C                   PARM                    RespMode          1
      *
      ** Front Office Id
     C                   PARM                    FOTRID           20
      *
      ** OUTPUT PARAMETERS:
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Collateral details (file format)
     C                   PARM                    CrCoFilFmt
      *
      ** OK Flags
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDCREFOK          1
     C                   PARM                    DDREVFOK          1
     C                   PARM                    DDREQROK          1
     C                   PARM                    DDSENTOK          1
     C                   PARM                    DDSCMPOK          1
     C                   PARM                    DDSBRCOK          1
     C                   PARM                    DDSCOLOK          1
     C                   PARM                    DDSCNUOK          1
     C                   PARM                    DDSCCYOK          1
     C                   PARM                    DDSVALOK          1
     C                   PARM                    DDSGNSOK          1
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLCOLLRTV  ' DBPGM
     C                   OUT       LDA
      **********                                                                             BUG6979
      ***Lock*in*data*area,*ZMUSER,*to*access*the*default*branch.                            BUG6979
      **********                                                                             BUG6979
     C******LOCK         IN        ZMUSER                                                    BUG6979
     C**********         UNLOCK    ZMUSER                                                    BUG6979
      **********                                                                             BUG6979
      ***Save*Default*Branch                                                                 BUG6979
      **********                                                                             BUG6979
     C**********         MOVE      DBRN          WWDBRN            3                         BUG6979
      **********                                                                             BUG6979
      ***Store*Job*User                                                                      BUG6979
      **********                                                                             BUG6979
     C**********         MOVEL     PSUser        WWUSER           10                         BUG6979
      *
      ** Access Bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if CGL018 is on.                                CGL018
      *                                                                                       CGL018
     C                   CALLB     'AOSARDR0'                                                 CGL018
     C                   PARM      *BLANKS       @RTCD                                        CGL018
     C                   PARM      '*VERIFY'     @OPTN                                        CGL018
     C                   PARM      'CGL018'      @SARD                                        CGL018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL018
      *                                                                                       CGL018
      ** Database Error                                                                       CGL018
      *                                                                                       CGL018
     C     @RTCD         IFNE      *BLANKS                                                    CGL018
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL018
     C                   Z-ADD     7             DBASE                                        CGL018
     C                   MOVEL     'CGL018'      DBKEY                                        CGL018
     C                   EXSR      *PSSR                                                      CGL018
     C                   END                                                                  CGL018
      *                                                                                       CGL018
     C     @RTCD         IFEQ      *BLANK                                                     CGL018
     C                   MOVE      'Y'           CGL018            1                          CGL018
     C                   ELSE                                                                 CGL018
     C                   MOVE      'N'           CGL018                                       CGL018
     C                   END                                                                  CGL018
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
