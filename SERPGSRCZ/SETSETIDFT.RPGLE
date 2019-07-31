     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlement instruction defaulting')     *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SETSETIDFT - Trade Settlement Instruction Defaulting.        *
      *                                                               *
      *  Function:  This module performs the defaulting procedure     *
      *             for the settlement instructions as well as the    *
      *             Originating Branch.                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7029            Date 09Jun05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE039             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204593             Date 03May02               *
      *                 CSE034             Date 22Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185733             Date 02Nov00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 31Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CA0016 *CREATE     Date 03Apr98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CSE039 - Auto-settlement of trades                           *
      *  204593 - Incorrect Deliver From/To Defaulting.               *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *  CSE022 - Depository Definition Enhancement                   *
      *  185733 - Addition of Depot A/C number for MG0565 (recompile) *
      *           (CSE023 - Treaty Withholding Tax)                   *
      *  CPB001 - 'Private Banking' Module                            *
      *           /COPY SE_CUSTDT Changed                             *
      *  CA0016 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSTDSED    IF   E           K DISK
 
     FACCNT     IF   E           K DISK
 
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
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Trade Settlement Instructions in screen format
     D TrSett        E DS                  EXTNAME(SETRSTPD)
 
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
 
      ** Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Security Customer details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CSE028
      ** DS for customer/book standard settlement instruction                                 CSE028
      **  to be passed to SESSIR0                                                             CSE028
      *                                                                                       CSE028
     D PCBSTD        E DS                  EXTNAME(STDSED) OCCURS(2)                          CSE028
      *                                                                                       CSE028
      ** Data structure for standard additional settlement details                            CSE028
      ** for customer/book to be passed to SESSIR0                                            CSE028
      *                                                                                       CSE028
     D PCBSAD        E DS                  EXTNAME(STDADSED) OCCURS(8)                        CSE028
 
     D PCBSTDX1      E DS                  EXTNAME(STDSED)                                    204593
     D                                     PREFIX(X1)                                         204593
 
     D DSACCT          DS
     D**CNUM****               1      6  0                                                    CSD027
     D  CNUM                   1      6A                                                      CSD027
     D  CCY                    7      9
     D**ACOD***               10     13  0                                                    CGL029
     D**ACSQ***               14     15  0                                                    CGL029
     D**BRCA***               16     18                                                       CGL029
     D  ACOD                  10     19  0                                                    CGL029
     D  ACSQ                  20     21  0                                                    CGL029
     D  BRCA                  22     24                                                       CGL029
 
 
     D RUNDAT          DS
      ** DATA STRUCTURE FOR RUNDAT.
     D  @MBIN                 13     13
 
     D ZMUSER          DS            17
      ** DATA STRUCTURE FOR USER DETAILS
     D  USRBCH                11     13
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Working variables
      ** -----------------
 
     D StFlg           S              1A
     D @SCKY           S              6A
     D*P@ACCD*         S              4A                                                      CGL029
     D P@ACCD          S             10A                                                      CGL029
     D P@ACSN          S              2A
     D P@BRCD          S              3A
     D P@CSSN          S             10A
     D P@CUST          S              6A
     D P@CYCD          S              3A
     D P@NONB          S              2A
     D P@PNOI          S              1A
     D WCUST           S              6A
     D*WOUT06*         S              6A                                                      CGL029
     D WOUT06          S             12A                                                      CGL029
     D CSE028          S              1A                                                      CSE028
     D POTYP           S              1A   INZ('D')                                           CSE028
     D PBRCH           S              3A                                                      CSE028
     D PCUST           S              6A                                                      CSE028
     D PBOOK           S              2A                                                      CSE028
     D PCURR           S              3A                                                      CSE028
     D PMRKT           S              2A                                                      CSE034
     D PINVT           S              3A                                                      CSE028
     D PPTFR           S              4A                                                      CSE028
     D PRTCD           S              5A                                                      CSE028
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *                                                                                      BUG7029
      ** READ ZMUSER - for default branch.                                                   BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
 
      *
      ** Initial processing
      *
     C                   EXSR      INIT
 
      *
      ** Retrieve Settlement details
      ** ---------------------------
      *
     C                   EXSR      SRSetDet
      *
      ** Primary & Secondary trades
      ** --------------------------
      *
     C     DDTDMI        IFEQ      'P'
     C     DDTDMI        OREQ      'S'
      *
      ** Trade Purchase
      ** --------------
      *
     C     DDTDTP        IFEQ      'TP'
      *
      ** Settlement Details present
      ** --------------------------
      *
     C     StFlg         IFEQ      'Y'
     C                   EXSR      TPDefSetD1
 
     C                   ELSE
      *
      ** Settlement Details undefined
      ** ----------------------------
      *
     C                   EXSR      TPDefSetD2
     C                   END
      *
      ** Secondary Defaulting
      ** --------------------
      *
     C                   EXSR      TPDefSetD3
      *
      ** Trade Sale
      ** ----------
      *
     C                   ELSE
      *
      ** Settlement Details present
      ** --------------------------
      *
     C     StFlg         IFEQ      'Y'
     C                   EXSR      TSDefSetD1
 
     C                   ELSE
      *
      ** Settlement Details undefined
      ** ----------------------------
     C                   EXSR      TSDefSetD2
     C                   END
      *
      ** Secondary Defaulting
      ** --------------------
      *
     C                   EXSR      TSDefSetD3
 
     C                   END
 
     C                   END
      *
      ** Originating Branch
      ** ------------------
      *
     C     DDORBR        IFEQ      *BLANKS
     C                   EXSR      DefOrgBrh
     C                   END
      *
      ** Auto-Settle Indicator
      ** ---------------------
      *
     C     DDAUTS        IFEQ      *BLANKS
     C                   EXSR      DefAutoSet
     C                   END
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
      *
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetDet - This subroutine retrives the defined settlement    *
      *            details for the customer (If any).                 *
      *                                                               *
      *****************************************************************
     C     SRSetDet      BEGSR
      *
      ** Access Standard Settlement details for Settlement currency.
      ** If customer exists.
      *
     C                   MOVE      'N'           StFlg
 
     C     CustNum       IFNE      *BLANKS
     C                   MOVEL     DDBRCD        SBRA
     C                   MOVEL     CustNum       CSTM
     C                   MOVEL     DDSETC        CYSI
     C                   MOVEL     SITP          ITSI
      *
      ** Define key list 1 for PF/STDSED
      *
     C     KLSTD1        KLIST
     C                   KFLD                    SBRA
     C                   KFLD                    CSTM
     C                   KFLD                    SIBK                                         CSE028
     C                   KFLD                    CYSI
      *
      ** Define key list 2 for PF/STDSED
      *
     C     KLSTD2        KLIST
     C                   KFLD                    SBRA
     C                   KFLD                    CSTM
     C                   KFLD                    SIBK                                         CSE028
     C                   KFLD                    CYSI
     C                   KFLD                    ITSI
     C                   KFLD                    SPTFR                                        CSE028
      *                                                                                       CSE028
     C                   EVAL      SIBK = *BLANKS                                             CSE028
     C                   EVAL      SPTFR = *BLANKS                                            CSE028
      *                                                                                       CSE028
      ** If CSE028 is on, call SESSIR0 for default of MT5xx information                       CSE028
      *                                                                                       CSE028
     C                   IF        CSE028 = 'Y'                                               CSE028
     C                   EVAL      *IN44 = *OFF                                               CSE028
     C                   MOVEL     CSTM          PCUST                                        CSE028
     C                   CALL      'SESSIR0'                                                  CSE028
     C                   PARM                    POTYP                                        CSE028
     C                   PARM      SBRA          PBRCH                                        CSE028
     C                   PARM                    PCUST                                        CSE028
     C                   PARM      DDBPBK        PBOOK                                        CSE028
     C                   PARM      CYSI          PCURR                                        CSE028
     C                   PARM      DDMRKT        PMRKT                                        CSE034
     C                   PARM      ITSI          PINVT                                        CSE028
     C                   PARM      PTFR          PPTFR                                        CSE028
     C                   PARM                    PCBSTD                                       CSE028
     C                   PARM                    PCBSAD                                       CSE028
     C                   PARM      *BLANKS       PRTCD                                        CSE028
      *                                                                                       CSE028
     C                   SELECT                                                               CSE028
      *                                                                                       CSE028
      ** Retrieve DS for Customer.                                                            CSE028
     C                   WHEN      PRTCD <> '*NRF ' AND PRTCD <> '*NCRF'                      CSE028
     C     1             OCCUR     PCBSTD                                                     204593
     C                   EVAL      PCBSTDX1 = PCBSTD                                          204593
     C     2             OCCUR     PCBSTD                                                     CSE028
     C                   IF        DDTDTP = 'TP' AND                                          204593
     C**********                   X1SDTO <> 0                                         204593 CSD027
     C                             X1SDTO <> *BLANKS                                          CSD027
     C                   EVAL      SDTO = X1SDTO                                              204593
     C                   EVAL      SFAT = *BLANKS                                             204593
     C                   ENDIF                                                                204593
     C                   IF        DDTDTP = 'TS' AND                                          204593
     C**********                   X1SDFO <> 0                                         204593 CSD027
     C                             X1SDFO <> *BLANKS                                          CSD027
     C                   EVAL      SDFO = X1SDFO                                              204593
     C                   EVAL      SFAF = *BLANKS                                             204593
     C                   ENDIF                                                                204593
      *                                                                                       CSE028
      ** Retrieve DS for Book.                                                                CSE028
     C                   WHEN      PRTCD <> '*NRF ' AND PRTCD <> '*NBRF'                      CSE028
     C     1             OCCUR     PCBSTD                                                     CSE028
      *                                                                                       CSE028
      ** Set on Record Not Found indicator.                                                   CSE028
     C                   OTHER                                                                CSE028
     C                   EVAL      *IN44 = *ON                                                CSE028
     C                   ENDSL                                                                CSE028
      *                                                                                       CSE028
     C                   ELSE                                                                 CSE028
      *
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
 
     C     KLSTD1        CHAIN     STDSEDF                            44
     C                   ELSE
     C     KLSTD2        CHAIN     STDSEDF                            44
     C                   END
      *                                                                                       CSE028
     C                   ENDIF                                                                CSE028
      *
      ** .. check existence
      *
     C     *IN44         IFEQ      '0'
     C     RECI          ANDNE     '*'
     C                   MOVE      'Y'           STFLG
     C                   END
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TPDefSetD1- This subroutine performs the defaulting procedure *
      * (Primary)   on the settlement fields for a Trade Purchase for *
      *             a customer who has a defined Settlement Inst.     *
      *                                                               *
      *****************************************************************
     C     TPDefSetD1    BEGSR
      *
      ** Do defaulting only if no settlement details present
      *
     C     DDSMTH        IFEQ      *BLANK
     C     DDPYFM        ANDEQ     *BLANK
     C     DDPAYT        ANDEQ     *BLANK
     C     DDTDFA        ANDEQ     *BLANK
     C     DDDFFA        ANDEQ     *BLANK
      *
      ** Settlement method
      ** -----------------
      *
     C     SPSM          IFNE      *ZEROS
     C                   MOVEL     SPSM          DDSMTH
     C                   ELSE
 
     C     CustClass     IFNE      'S'
     C     CustClass     ANDNE     'D'
     C                   MOVE      '01'          DDSMTH
     C                   ELSE
 
     C     CustAcCd      IFNE      *BLANKS
     C                   MOVE      '15'          DDSMTH
     C                   END
 
     C                   END
     C                   END
      *
      ** Pay From
      ** --------
      *
     C     SPAT          IFNE      *BLANKS
     C                   MOVEL     SPAT          DDPYFM
     C                   END
      *
      ** Pay from branch
      ** ---------------
      *
     C     SPBA          IFNE      *ZEROS
     C                   MOVEL     SPBA          DDPYFB
      *
      ** Pay to branch
      ** -------------
      *
     C                   MOVEL     SPBA          DDPYTB
     C                   END
      *
      ** Pay to
      ** ------
      *
     C     SPCB          IFNE      *BLANKS
     C                   MOVEL     SPCB          DDPAYT
     C                   ELSE
 
     C     DDSMTH        IFEQ      '01'
     C                   MOVEL     CustNum       DDPAYT
     C                   END
 
     C                   END
      *
      ** For a/c of (Pay To)
      ** -------------------
      *
     C                   MOVEL     SPFA          DDTDFA
      *
      ** For a/c of (Deliver from theirs)
      ** --------------------------------
      *
     C                   MOVEL     SFAF          DDDFFA
 
     C                   END
 
      *
      ** Special instructions
      ** --------------------
      *
     C     DDTDSI        IFEQ      *BLANK
     C                   MOVEL     SPSI          DDTDSI
     C                   END
      *
      ** Clearance type
      ** --------------
      *
     C     DDCLTY        IFEQ      *BLANK
     C                   MOVEL     SCLP          DDCLTY
     C                   END
      *
      ** Pay code
      ** --------
      *
     C     DDPCOD        IFEQ      *BLANK
     C                   MOVEL     SPCP          DDPCOD
     C     SPCP          IFEQ      *BLANKS
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
     C                   MOVE      '3'           DDPCOD
     C                   ELSE
     C                   MOVE      '1'           DDPCOD
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TPDefSetD2- This subroutine performs the defaulting procedure *
      * (Primary)   on the settlement fields for a Trade Purchase for *
      *             a customer without a defined Settlement Inst.     *
      *                                                               *
      *****************************************************************
     C     TPDefSetD2    BEGSR
      *
      ** Do defaulting only if no settlement details present
      *
     C     DDSMTH        IFEQ      *BLANK
     C     DDPAYT        ANDEQ     *BLANK
      *
      ** Settlement method
      ** -----------------
      *
     C     DDINCS        IFEQ      'I'
     C                   MOVE      '00'          DDSMTH
     C                   ELSE
 
     C     CustClass     IFNE      'S'
     C     CustClass     ANDNE     'D'
     C                   MOVE      '01'          DDSMTH
     C                   ELSE
 
     C     CustAcCd      IFNE      *BLANKS
     C                   MOVE      '15'          DDSMTH
     C                   END
 
     C                   END
     C                   END
      *
      ** Pay To
      ** ------
      *
     C     DDSMTH        IFEQ      '01'
     C                   MOVEL     CustNum       DDPAYT
     C                   END
 
     C                   END
      *
      ** Pay code
      ** --------
      *
     C     DDPCOD        IFEQ      *BLANK
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
     C                   MOVE      '3'           DDPCOD
     C                   ELSE
     C                   MOVE      '1'           DDPCOD
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TSDefSetD1- This subroutine performs the defaulting procedure *
      * (Primary)   on the settlement fields for a Trade Sale for a   *
      *             customer with a defined Settlement Inst.          *
      *                                                               *
      *****************************************************************
     C     TSDefSetD1    BEGSR
      *
      ** Do defaulting only if no settlement details present
      *
     C     DDSMTH        IFEQ      *BLANK
     C     DDPYFM        ANDEQ     *BLANK
     C     DDPAYT        ANDEQ     *BLANK
     C     DDDTFA        ANDEQ     *BLANK
      *
      ** Settlement Method
      ** -----------------
      *
     C     SRSM          IFNE      *ZEROS
     C                   MOVEL     SRSM          DDSMTH
     C                   ELSE
 
     C     CustClass     IFNE      'S'
     C     CustClass     ANDNE     'D'
     C                   MOVE      '01'          DDSMTH
     C                   ELSE
 
     C     CustAcCd      IFNE      *BLANKS
     C                   MOVE      '15'          DDSMTH
     C                   END
 
     C                   END
     C                   END
      *
      ** Pay from
      ** --------
      *
     C     SRCB          IFNE      *BLANKS
     C                   MOVEL     SRCB          DDPYFM
     C                   ELSE
     C     DDSMTH        IFEQ      '01'
     C                   MOVEL     CustNum       DDPYFM
     C                   END
 
     C                   END
      *
      ** Pay from branch
      ** ---------------
      *
     C     SRAB          IFNE      *ZEROS
     C                   MOVEL     SRAB          DDPYFB
      *
      ** Pay to branch
      ** -------------
      *
     C                   MOVEL     SRAB          DDPYTB
     C                   END
      *
      ** Pay to
      ** ------
      *
     C     SRAC          IFNE      *BLANKS
     C                   MOVEL     SRAC          DDPAYT
     C                   END
      *
      ** For a/c of (Deliver To)
      ** -----------------------
      *
     C                   MOVEL     SFAT          DDDTFA
 
     C                   END
 
      *
      ** Clearance type
      ** --------------
      *
     C     DDCLTY        IFEQ      *BLANK
     C                   MOVEL     SCLS          DDCLTY
     C                   END
      *
      ** Pay code
      ** --------
      *
     C     DDPCOD        IFEQ      *BLANK
     C                   MOVEL     SPCS          DDPCOD
     C     SPCS          IFEQ      *BLANKS
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
     C                   MOVE      '3'           DDPCOD
     C                   ELSE
     C                   MOVE      '1'           DDPCOD
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TSDefSetD2- This subroutine performs the defaulting procedure *
      * (Primary)   on the settlement fields for a Trade Sale for a   *
      *             customer without a defined Settlement Inst.       *
      *                                                               *
      *****************************************************************
     C     TSDefSetD2    BEGSR
      *
      ** Do defaulting only if no settlement details present
      *
     C     DDSMTH        IFEQ      *BLANK
     C     DDPYFM        ANDEQ     *BLANK
      *
      ** Settlement method
      ** -----------------
      *
     C     DDINCS        IFEQ      'I'
     C                   MOVE      '00'          DDSMTH
     C                   ELSE
 
     C     CustClass     IFNE      'S'
     C     CustClass     ANDNE     'D'
     C                   MOVE      '01'          DDSMTH
     C                   ELSE
 
     C     CustAcCd      IFNE      *BLANKS
     C                   MOVE      '15'          DDSMTH
     C                   END
 
     C                   END
     C                   END
      *
      ** Pay From
      ** --------
      *
     C     DDSMTH        IFEQ      '01'
     C                   MOVEL     CustNum       DDPYFM
     C                   END
 
     C                   END
 
      *
      ** Pay code
      ** --------
      *
     C     DDPCOD        IFEQ      *BLANK
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
     C                   MOVE      '3'           DDPCOD
     C                   ELSE
     C                   MOVE      '1'           DDPCOD
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TPDefSetD3- This subroutine performs the secondary defaulting *
      * (Primary)   on the settlement fields for a Trade Purchase.    *
      *                                                               *
      *****************************************************************
     C     TPDefSetD3    BEGSR
      *
      ** Pay From/Branch for Euclid currencies if method 01
      ** ---------------
      *
     C     DDPYFM        IFEQ      *BLANKS
     C     DDSMTH        ANDEQ     '01'
 
     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'
 
     C     DDCLTY        IFEQ      '1'
     C     DDCLTY        OREQ      '2'
     C     DDCLTY        OREQ      '3'
     C     DDCLTY        OREQ      '4'
     C                   MOVE      *BLANKS       DDPYFM
      *
      **  .. load Euroclear nostro code if Clearance Type = 1 or 2
      *
     C     DDCLTY        IFEQ      '1'
     C     DDCLTY        OREQ      '2'
     C                   MOVEL     SetCcyECDN    DDPYFM
     C                   ELSE
      *
      **  .. load Cedel nostro code if Clearance Type = 3 or 4
      *
     C                   MOVEL     SetCcyCDFN    DDPYFM
     C                   END
      *
      **  .. load Pay From Branch
      *
     C     DDPYFM        IFNE      *BLANKS
     C                   MOVE      '*DBERR '     @RTCD
     C                   MOVE      DDSETC        P@CYCD
     C                   MOVEL     DDPYFM        P@NONB
 
     C                   EXSR      AONOST
 
     C                   MOVEL     A7ACCD        ACOD
     C                   MOVEL     A7BRCD        BRCA
     C                   MOVEL     A7CUST        CNUM
     C                   MOVEL     A7ACSN        ACSQ
     C                   MOVEL     DDSETC        CCY
 
     C     KLACCT        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
 
     C     KLACCT        CHAIN     ACCNTABF                           44
 
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDEQ     '*'
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     DSACCT        DBKEY
     C                   MOVEL     'ACCNT'       DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 902*
     C                   EXSR      SRERR                                        ************
 
     C                   ELSE
      *
     C                   MOVEL     A7BRCD        DDPYFB
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ** Pay From/Branch if method 15
      ** ---------------
      *
     C     DDPYFM        IFEQ      *BLANKS
     C     DDSMTH        ANDEQ     '15'
     C     CustAcCd      ANDNE     *BLANKS
     C                   MOVEL     CustNum       DDPYFM
     C                   MOVEL     CustAcCd      WOUT06
     C                   MOVE      CustAcSq      WOUT06
     C                   MOVE      WOUT06        DDPYFM
     C                   MOVE      DDBRCD        DDPYFB
     C                   END
      *
      ** Priority code
      ** ------------
      *
     C     DDPRYC        IFEQ      *BLANKS
     C                   MOVE      'R'           DDPRYC
     C                   END
      *
      ** Deliver from
      ** ------------
      *
     C     DDDELF        IFEQ      *BLANKS
 
     C     STFLG         IFNE      'Y'
     C     STFLG         OREQ      'Y'
     C*****SDFT*         ANDEQ     *ZEROS                                                     CSD027
     C     SDFT          ANDEQ     *BLANKS                                                    CSD027
 
     C     DDCLTY        IFEQ      '1'
 
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
      *
     C     CustDpRef1    IFNE      *BLANKS
     C                   MOVEL     CustDpRef1    DDDELF
     C                   ELSE
     C                   MOVE      BBIntCust     WCUST
     C                   MOVE      '*DBERR '     @RTCD
 
     C                   EXSR      AOSECS
 
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C     BFDRF1        IFNE      *BLANKS
     C                   MOVEL     BFDRF1        DDDELF
     C                   MOVEL     BFPNP1        CustPNP1
     C                   ELSE
     C                   MOVEL     BVDR1         DDDELF
     C                   END
 
     C                   END
      *
     C                   ELSE
      *
     C                   MOVEL     BVDR1         DDDELF
      *
     C                   END
     C                   END
      *
     C     DDCLTY        IFEQ      '3'
      *
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
      *
     C     CustDpRef2    IFNE      *BLANKS
     C                   MOVEL     CustDpRef2    DDDELF
     C                   ELSE
     C                   MOVE      BBIntCust     WCUST
     C                   MOVE      '*DBERR '     @RTCD
 
     C                   EXSR      AOSECS
 
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C     BFDRF2        IFNE      *BLANKS
     C                   MOVEL     BFDRF2        DDDELF
     C                   MOVEL     BFPNP2        CustPNP2
     C                   ELSE
     C                   MOVEL     BVDR2         DDDELF
     C                   END
     C                   END
      *
     C                   ELSE
      *
     C                   MOVEL     BVDR2         DDDELF
      *
     C                   END
     C                   END
      *
     C                   ELSE
 
     C*****SDFT*         IFNE      *ZEROS                                                     CSD027
     C     SDFT          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     SDFT          DDDELF
     C                   END
     C                   END
     C                   END
      *
      ** Deliver to
      ** ----------
      *
     C     DDDELT        IFEQ      *BLANKS
 
     C     STFLG         IFNE      'Y'
     C     STFLG         OREQ      'Y'
     C*****SDTO*         ANDEQ     *ZEROS                                                     CSD027
     C     SDTO          ANDEQ     *BLANKS                                                    CSD027
      *
     C     DDCLTY        IFEQ      '1'
     C     DDCLTY        OREQ      '2'
     C                   MOVEL     BVDR1         DDDELT
      *
     C                   ELSE
     C     DDCLTY        IFEQ      '3'
     C     DDCLTY        OREQ      '4'
     C                   MOVEL     BVDR2         DDDELT
     C                   END
     C                   END
      *
     C                   ELSE
 
     C*****SDTO*         IFNE      *ZEROS                                                     CSD027
     C     SDTO          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     SDTO          DDDELT
     C                   END
 
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TSDefSetD3- This subroutine performs the secondary defaulting *
      *             on the settlement fields for a Trade Sale.        *
      *                                                               *
      *****************************************************************
     C     TSDefSetD3    BEGSR
      *
      ** Pay To/Branch for Euclid currencies if method 01
      ** -------------
      *
     C     DDPAYT        IFEQ      *BLANKS
     C     DDSMTH        ANDEQ     '01'
 
     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'
 
     C     DDCLTY        IFEQ      '1'
     C     DDCLTY        OREQ      '2'
     C     DDCLTY        OREQ      '3'
     C     DDCLTY        OREQ      '4'
      *
      **  .. load Euroclear nostro code if Clearance Type = 1 or 2
      *
     C     DDCLTY        IFEQ      '1'
     C     DDCLTY        OREQ      '2'
     C                   MOVEL     SetCcyECDN    DDPAYT
     C                   ELSE
      *
      **  .. load Cedel nostro code if Clearance Type = 3 or 4
      *
     C                   MOVEL     SetCcyCDFN    DDPAYT
     C                   END
      *
      **  .. load Pay To Branch
      *
     C     DDPAYT        IFNE      *BLANKS
      *
     C                   MOVE      '*DBERR '     @RTCD
     C                   MOVE      DDSETC        P@CYCD
     C                   MOVEL     DDPAYT        P@NONB
 
     C                   EXSR      AONOST
 
     C                   MOVEL     A7ACCD        ACOD
     C                   MOVEL     A7BRCD        BRCA
     C                   MOVEL     A7CUST        CNUM
     C                   MOVEL     A7ACSN        ACSQ
     C                   MOVEL     DDSETC        CCY
 
     C     KLACCT        CHAIN     ACCNTABF                           44
 
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDEQ     '*'
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     DSACCT        DBKEY
     C                   MOVEL     'ACCNT'       DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 903*
     C                   EXSR      SRERR                                        ************
     C                   ELSE
      *
     C                   MOVEL     A7BRCD        DDPYTB
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ** Pay To/Branch if method 15
      ** -------------
      *
     C     DDPAYT        IFEQ      *BLANKS
     C     DDSMTH        ANDEQ     '15'
     C     CustAcCd      ANDNE     *BLANKS
     C                   MOVEL     CustNum       DDPAYT
     C                   MOVEL     CustAcCd      WOUT06
     C                   MOVE      CustAcSq      WOUT06
     C                   MOVE      WOUT06        DDPAYT
     C                   MOVE      DDBRCD        DDPYTB
     C                   END
      *
      ** Priority code
      ** -------------
      *
     C     DDPRYC        IFEQ      *BLANKS
     C                   MOVE      'R'           DDPRYC
     C                   END
      *
      ** Deliver from
      ** ------------
      *
     C     DDDELF        IFEQ      *BLANKS
 
     C     STFLG         IFNE      'Y'
     C     STFLG         OREQ      'Y'
     C*****SDFO*         ANDEQ     *ZEROS                                                     CSD027
     C     SDFO          ANDEQ     *BLANKS                                                    CSD027
      *
     C     DDCLTY        IFEQ      '1'
     C     DDCLTY        OREQ      '2'
     C                   MOVEL     BVDR1         DDDELF
      *
     C                   ELSE
     C     DDCLTY        IFEQ      '3'
     C     DDCLTY        OREQ      '4'
     C                   MOVEL     BVDR2         DDDELF
     C                   END
      *
     C                   END
      *
     C                   ELSE
     C*****SDFO*         IFNE      *ZEROS                                                     CSD027
     C     SDFO          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     SDFO          DDDELF
     C                   END
     C                   END
     C                   END
      *
      ** Deliver to
      ** ----------
      *
     C     DDDELT        IFEQ      *BLANKS
 
     C     STFLG         IFNE      'Y'
     C     STFLG         OREQ      'Y'
     C*****SDTT*         ANDEQ     *ZEROS                                                     CSD027
     C     SDTT          ANDEQ     *BLANKS                                                    CSD027
      *
     C     DDCLTY        IFEQ      '1'
     C                   MOVEL     BVDR1         DDDELT
      *
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
      *
     C     CustDpRef1    IFNE      *BLANKS
     C                   MOVEL     CustDpRef1    DDDELT
     C                   ELSE
     C                   MOVE      BBIntCust     WCUST
     C                   MOVE      '*DBERR '     @RTCD
 
     C                   EXSR      AOSECS
 
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C     BFDRF1        IFNE      *BLANKS
     C                   MOVEL     BFDRF1        DDDELT
     C                   MOVEL     BFPNP1        CustPNP1
     C                   ELSE
     C                   MOVEL     BVDR1         DDDELF
     C                   END
 
     C                   END
      *
     C                   ELSE
      *
     C                   MOVEL     BVDR1         DDDELF
      *
     C                   END
     C                   END
      *
     C     DDCLTY        IFEQ      '3'
      *
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
      *
     C     CustDpRef2    IFNE      *BLANKS
     C                   MOVEL     CustDpRef2    DDDELT
     C                   ELSE
     C                   MOVE      BBIntCust     WCUST
     C                   MOVE      '*DBERR '     @RTCD
 
     C                   EXSR      AOSECS
 
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C     BFDRF2        IFNE      *BLANKS
     C                   MOVEL     BFDRF2        DDDELT
     C                   MOVEL     BFPNP2        CustPnP2
     C                   ELSE
     C                   MOVEL     BVDR2         DDDELT
     C                   END
 
     C                   END
      *
     C                   ELSE
      *
     C                   MOVEL     BVDR2         DDDELT
      *
     C                   END
     C                   END
      *
     C                   ELSE
 
     C*****SDTT*         IFNE      *ZEROS                                                     CSD027
     C     SDTT          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     SDTT          DDDELT
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DefOrgBrh - This subroutine performs the defaulting procedure *
      *             for the Original branch.                          *
      *                                                               *
      *****************************************************************
     C     DefOrgBrh     BEGSR
 
     C     @MBIN         IFNE      'Y'
     C                   MOVE      USRBCH        DDORBR
     C                   ELSE
     C                   MOVE      DDBRCD        DDORBR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DefAutoSet - This subroutine performs the defaulting procedure*
      *              for the Autosettle indicator                     *
      *                                                               *
      *****************************************************************
     C     DefAutoSet    BEGSR
      *
      * If CSE039 is ON and Standard Settlement Instructions exist then                       CSE039
      * default Auto-settle indicator to be this value.                                       CSE039
     C     CSE039        IFEQ      'Y'                                                        CSE039
     C     STFLG         ANDEQ     'Y'                                                        CSE039
      *                                                                                       CSE039
     C                   MOVE      SASI          DDAUTS                                       CSE039
     C                   ELSE                                                                 CSE039
     C     DDTDMI        IFNE      'G'
     C                   MOVE      CustAUTS      DDAUTS
     C                   ELSE                                                                  E2029
     C                   MOVE      'N'           DDAUTS                                        E2029
     C                   END                                                                   E2029
     C                   ENDIF                                                                CSE039
 
 
     C                   IF        CSE039 = 'Y' AND CustClass = 'M'                           CSE039
                                                                                              CSE039
      ** Re-default the Auto-Settle indicator with the value held for the                     CSE039
      *  Depo Customer if it exist.                                                           CSE039
      *                                                                                       CSE039
     C                   EVAL      PCUST = *BLANKS                                            CSE039
      *                                                                                       CSE039
      ** If Trade Purchase use Deliver To Customer                                            CSE039
      *  If Trade Sale use Deliver From Customer                                              CSE039
     C                   IF        DDTDTP = 'TP'                                              CSE039
     C                   IF        DDDELT <> *BLANKS                                          CSE039
     C                   MOVEL     DDDELT        PCUST                                        CSE039
     C                   ENDIF                                                                CSE039
     C                   ELSE                                                                 CSE039
     C                   IF        DDDELF <> *BLANKS                                          CSE039
     C                   MOVEL     DDDELF        PCUST                                        CSE039
     C                   ENDIF                                                                CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   IF        PCUST <> *BLANKS                                           CSE039
     C                   CALL      'SESSIR0'                                                  CSE039
     C                   PARM                    POTYP                                        CSE039
     C                   PARM      SBRA          PBRCH                                        CSE039
     C                   PARM                    PCUST                                        CSE039
     C                   PARM      DDBPBK        PBOOK                                        CSE039
     C                   PARM      CYSI          PCURR                                        CSE039
     C                   PARM      DDMRKT        PMRKT                                        CSE039
     C                   PARM      ITSI          PINVT                                        CSE039
     C                   PARM      PTFR          PPTFR                                        CSE039
     C                   PARM                    PCBSTD                                       CSE039
     C                   PARM                    PCBSAD                                       CSE039
     C                   PARM      *BLANKS       PRTCD                                        CSE039
      *                                                                                       CSE039
      ** Retrieve DS for Customer.                                                            CSE039
     C                   IF        PRTCD <> '*NRF ' AND PRTCD <> '*NCRF'                      CSE039
     C     2             OCCUR     PCBSTD                                                     CSE039
     C                   IF        RECI = 'D'                                                 CSE039
     C                   MOVE      SASI          DDAUTS                                       CSE039
     C                   ENDIF                                                                CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   IF        PRTCD = '*NRF ' OR PRTCD = '*NCRF'                         CSE039
     C                             OR RECI <> 'D'                                             CSE039
      ** If no record found then use the Aut-Sett indicator from SDSEC                        CSE039
     C                   MOVE      PCUST         WCUST                                        CSE039
     C                   EXSR      AOSECS                                                     CSE039
     C                   MOVE      BFASIN        DDAUTS                                       CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   IF        PCUST = *BLANKS                                            CSE039
     C                   EVAL      DDAUTS = *BLANKS                                           CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AONOST - Subroutine to retrive Nosto Details                  *
      *                                                               *
      *****************************************************************
     C     AONOST        BEGSR
 
     C                   CALLB     'AONOSTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       P@CUST
     C                   PARM                    P@CYCD
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSN
     C                   PARM                    P@NONB
     C                   PARM      *BLANKS       P@BRCD
     C                   PARM      *BLANKS       P@CSSN
     C                   PARM      *BLANKS       P@PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOSECS -   Subroutine to access Security Customer details     *
      *                                                               *
      *****************************************************************
     C     AOSECS        BEGSR
 
     C                   CALLB     'AOSECSR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCUST         @SCKY
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INIT - This subroutine performs initial processing            *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
 
      * Get booking branch details
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCD        @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     DDBRCD        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ************
     C                   MOVEL     '800'         DBASE                          * DBERR 900*
     C                   EXSR      SRERR                                        ************
     C                   END
 
     C                   MOVEL     A8BICN        BBIntCust         6
 
      ** Check if CSE039 is installed                                                         CSE039
     C                   CALL      'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD             7                          CSE039
     C                   PARM      '*VERIFY'     @OPTN             7                          CSE039
     C                   PARM      'CSE039'      @SARD             6                          CSE039
      *                                                                                       CSE039
     C     @RTCD         IFEQ      *BLANKS                                                    CSE039
     C                   MOVE      'Y'           CSE039            1                          CSE039
     C                   ELSE                                                                 CSE039
     C                   MOVE      'N'           CSE039                                       CSE039
     C                   ENDIF                                                                CSE039
                                                                                              CSE039
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      ** Booking branch
      ** Incomplete Ind
      ** Trade Type
      ** Settlement Currency
      ** Market Ind.
      ** Book Code.                                                                           CSE028
      ** Market Centre                                                                        CSE034
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDINCS            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETC            3
     C                   PARM                    DDTDMI            1
     C                   PARM                    DDBPBK            2                          CSE028
     C                   PARM                    DDMRKT            2                          CSE034
 
      ** Investment type
 
     C                   PARM                    SITP              3
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
 
      ** Customer (Counterparty) Details
      ** ( Note: Customer Participant/Non-participant Indicator 1 and
      **  Customer Participant/Non-participant Indicator 2 are also outputs)
     C                   PARM                    CustDts                                       S0111
 
 
      ** ICD
      ** Depot 1 (Eurclear)
      ** Depot 2 (Cedel)
     C                   PARM                    BVDR1             6
     C                   PARM                    BVDR2             6
      *                                                                                       CSE028
      ** MT5xx SSI (Phase 2)                                                                  CSE028
     C                   PARM                    CSE028                                       CSE028
 
      * OUTPUTS
 
      ** Trade Settlement Instructions
 
     C                   PARM                    TrSett
 
      *
      ** READ RUNDAT - for multi-branching ind
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      **********                                                                             BUG7029
      ***READ*ZMUSER*-*for*default*branch.                                                   BUG7029
      **********                                                                             BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SETSETIDFT'  DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminate the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
