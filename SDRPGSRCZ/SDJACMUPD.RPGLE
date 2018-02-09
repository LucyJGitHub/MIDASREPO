     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Update')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACMUPD - Midas SD Joint Account Member Details Update     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD036377           Date 30Oct15               *
      *                 MD033947           Date 28Apr15               *
      *                 MD030151           Date 05Sep14               *
      *                 CER070             Date 19Aug14               *
      *                 CER069             Date 03Jul14               *
      *                 MD026854           Date 29May14               *
      *                 MD026790           Date 29May14               *
      *                 CGL132             Date 01May13               *
      *                 CSD092             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23732           Date 23Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036377 - Database error upon F12 cancel                    *
      *  MD033947 - Database Error occurred when amending US Indicia  *
      *             details of Non-account Holder                     *
      *  MD030151 - Exceptions with JACM Update - The customer is not *
      *             exempt and flagged as joint account but there is  *
      *             no joint account members defined                  *
      *             Applied fix MD027576                              *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER069 - German Tax Enhancement                              *
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
      *  MD026790 - Update Exceptions with JACM Updates               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSD092 - Account Review                                      *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23732 - Joint Account Threshold                           *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDJACCL9  UF A E           K DISK    INFSR(*PSSR)
      ** Midas SD Joint A/c Member Details by Joint A/c No./Customer No./Non-a/c Holder
 
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@AHREAU:SDFCTLD0)
      ** Midas SD Standing Data Controls
      *                                                                                     BUG23732
      ** Midas SD Interest  Payment History File                                            BUG23732
      *                                                                                     BUG23732
     FSDINPHL0  UF A E           K DISK    INFSR(*PSSR)                                     BUG23732
      *                                                                                     BUG23732
      ** Midas SD Exemption Threshold History File                                          BUG23732
      *                                                                                     BUG23732
     FSDTHRHL3  UF A E           K DISK    INFSR(*PSSR)                                     BUG23732
      *                                                                                     BUG23732
      ** SD Cust Details by Country fo Tax                                                  BUG23732
      *                                                                                     BUG23732
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG23732
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation Error Array Declarations
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** 24x7 Status Data Area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Valid Joint A/c Member Details
     D SDVJACM       E DS                  EXTNAME(SDVJACMPD) PREFIX(A_:2)
 
      ** Joint A/c Member Details - Before Update
     D B_JAcM        E DS                  EXTNAME(SDJACCPD) PREFIX(B_:2)
 
      ** Joint A/c Member Details - Timestamp Check
     D JAcMChkFmt    E DS                  EXTNAME(SDJACCPD) PREFIX(C_:2)
 
      ** Joint A/c Member Details Data Structure
     D SDJACM        E DS                  EXTNAME(SDJACCPD)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Switchable Feature Details Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** API Message Header Format Definition
     D APHEAD        E DS                  EXTNAME(APHEADPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                     BUG23732
      ** Long DS for access programs, long data structure                                   BUG23732
      *                                                                                     BUG23732
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG23732
      *                                                                                     BUG23732
      ** Second DS for access programs, long data structure                                 BUG23732
      *                                                                                     BUG23732
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   BUG23732
      *                                                                                     BUG23732
      ** External DS for Branch Details                                                     BUG23732
      *                                                                                     BUG23732
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                BUG23732
      *                                                                                     BUG23732
      ** External DS for Location  Details                                                  BUG23732
      *                                                                                     BUG23732
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG23732
      *                                                                                     BUG23732
      ** External DS for Custoter Details                                                   BUG23732
      *                                                                                     BUG23732
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG23732
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                   BUG23732
      *                                                                                     BUG23732
      ** Data Structure for Additional Customer Details                                     BUG23732
      *                                                                                     BUG23732
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                                BUG23732
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S             10A
 
      ** API Parameters
     D POprMode        S              6A
     D PResMode        S              1A
     D PDACTN          S              1A
     D PDFRNT          S             20A
     D PDJANO          S              6A
     D PDCUST          S              6A
     D PDNAHO          S             10A
     D PDACTD          S              1A
     D OKACTN          S              1A
     D OKCUST          S              1A
     D OKNAHO          S              1A
     D PRetCodeOut     S             10A
     D TRANSDTL        S           5800A
     D PTimestamp      S             26A
     D PKey            S             18A
     D PAKey           S             18A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARD           S              6A
 
      ** Standard Utility Parameters
     D PZRtrn          S              6A
     D PZRtCd          S             10A
     D PZType          S              1A
     D PZDBErr         S            132A
     D PZMsgID         S              7A
     D PZMsgF          S             10A
     D PZTmst          S               Z
 
      ** Switchable Features
     D CSC011          S              1A   INZ('N')
     D CSD092          S              1A   INZ('N')                                           CSD092
 
      ** Key Fields
     D KJANo           S                   LIKE(JCJANO)
     D KCust           S                   LIKE(JCCUST)
     D KNAHo           S                   LIKE(JCNAHO)
     D KFLNM           S                   LIKE(AHFLNM)
 
      ** Working Variables
     D WI              S              3P 0
     D Ix              S              3P 0
                                                                                              CSD092
     D PBefCUST        S           5000A                                                      CSD092
     D PAftCUST        S           5000A                                                      CSD092
     D PBefACUS        S           5000A                                                      CSD092
     D PAftACUS        S           5000A                                                      CSD092
     D PBefFTCS        S           5000A                                                      CGL132
     D PAftFTCS        S           5000A                                                      CGL132
     D PBefJACC        S           5000A                                                      CSD092
     D PAftJACC        S           5000A                                                      CSD092
     D PBefCUAH        S           5000A                                                      CSD092
     D PAftCUAH        S           5000A                                                      CSD092
     D PBefCUXC        S           5000A                                                    MD026854
     D PAftCUXC        S           5000A                                                    MD026854
     D PACRV           S              1A                                                      CSD092
     D PELEC           S              1A                                                      CGL132
     D CER048          S              1A                                                    BUG23732
     D PCust           S             10A                                                    BUG23732
     D PCustT          S              6A                                                    BUG23732
     D PKySt           S              7A                                                    BUG23732
     D PBrca           S              3A                                                    BUG23732
     D PLocn           S              3A                                                    BUG23732
     D KCtax           S              2A                                                    BUG23732
     D CER069          S              1A                                                      CER069
     D PCommitCUSD     S              1A                                                    MD033947
     D PCommitNAHL     S              1A                                                    MD033947
      ** Override SDFTCSPD, SDFTNHPD                                                        MD027576
     D CMDNH           S             50    DIM(1) CTDATA PERRCD(1)                          MD027576
     D CMDCS           S             50    DIM(1) CTDATA PERRCD(1)                          MD027576
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Check for updates by other workstations.
 
     C                   EXSR      SRChkWksUpd
 
     C                   IF        PRetCode <> *BLANKS
     C                   RETURN
     C                   ENDIF
 
      ** Insert, amend, or delete Joint A/c Member details.
 
     C                   SELECT
 
     C                   WHEN      A_CHTP = 'I'
     C                   EXSR      SRIJAcM
 
     C                   WHEN      A_CHTP = 'A'
     C                   EXSR      SRAJAcM
 
     C                   WHEN      A_CHTP = 'D'
     C                   EXSR      SRDJAcM
 
     C                   ENDSL
      *                                                                                     MD026790
      ** Invoke exceptions update program                                                   MD026790
      *                                                                                     MD026790
     C                   CALL      'SD000715'                                               MD026790
     C                   PARM                    A_JANO                                     MD026790
     C                   PARM      '0'           PCommitCUSD                                MD036377
     C                   PARM      '0'           PCommitNAHL                                MD033947
      *                                                                                     BUG23732
     C                   IF        CER048 = 'Y' AND                                         BUG23732
     C                             A_CUST <> *BLANKS  AND                                   BUG23732
     C                             (A_CHTP = 'I' OR                                         BUG23732
     C                             A_CHTP = 'A')                                            BUG23732
      *                                                                                     BUG23732
      ** To get the Details for Exemption Threshold at Joint                                BUG23732
      ** Account Level                                                                      BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOACUSR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY'        POptn                                      BUG23732
     C                   PARM      A_CUST        PCust                                      BUG23732
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS AND                                     BUG23732
     C                             PRtcd <> '*NRF'                                          BUG23732
     C                   EVAL      DBKEY = PCust                                            BUG23732
     C                   EVAL      DBFILE = 'SDACUSPD'                                      BUG23732
     C                   EVAL      DBASE = 107                                              BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd = '*NRF'                                           BUG23732
     C                   EVAL      E5EXTH =  *ZEROS                                         BUG23732
     C                   EVAL      E5EADT =  *ZEROS                                         BUG23732
     C                   EVAL      E5EVDT =  *ZEROS                                         BUG23732
     C                   EVAL      E5ETXT =  *ZEROS                                         BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   EXSR      SRWrHiFl                                                 BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
 
      ** Update Standing Data Controls.
 
     C                   EXSR      SRFCTL
 
      ** Run 24x7 processing if necessary.
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SOVR = 'S'
     C                   EXSR      SR24x7
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIJAcM - Inserts Joint A/c Member details.                  *
      *                                                               *
      *****************************************************************
     C     SRIJAcM       BEGSR
 
      ** Check first if the record exists.
 
     C                   EVAL      KJANo = A_JANO
     C                   EVAL      KCust = A_CUST
     C                   EVAL      KNAHo = A_NAHO
 
     C     KJAC9         CHAIN     SDJACCL9
 
     C                   IF        %FOUND
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDJACCPD'
     C                   EVAL      DBKey = A_JANO + A_CUST + A_NAHO
     C                   EVAL      DBase = 103
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CLEAR                   SDJACM
 
      ** Update 'Before Image'.
 
     C                   MOVEL(P)  SDJACM        B_JAcM
 
     C                   EVAL      JCJANO = A_JANO
     C                   EVAL      JCCUST = A_CUST
     C                   EVAL      JCNAHO = A_NAHO
     C                   EVAL      JCINVP = A_INVP
     C                   EVAL      JCPAHT = A_PAHT
     C                   EVAL      JCPAHO = A_PAHO
     C                   EVAL      JCCHTP = A_CHTP
     C                   EVAL      JCLCDT = BJRDNB
     C                   EVAL      JCFRNT = A_FRNT
     C                   EVAL      JCREPA = A_REPA
 
      ** If CSC011 is installed, supply a Front Office ID for the
      ** transaction even if it originated from SIN module.
 
     C                   IF        CSC011 = 'Y'
     C                   IF        JCFRNT = *BLANKS
     C                   EVAL      JCFRNT = 'MD' + JCJANO
     C                   ENDIF
     C                   ENDIF
 
      ** Get timestamp.
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PZTmst
 
     C                   EVAL      JCTMST = PZTmst
 
     C                   WRITE     SDJACCD0
 
     C                   IF        CSD092 = 'Y'                                               CSD092
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      JCJANO        PCUST                                        CSD092
     C                   PARM      *BLANKS       PBefCUST                                     CSD092
     C                   PARM      *BLANKS       PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      *BLANKS       PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      SDJACM        PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAJAcM - Amends Joint A/c Member details.                   *
      *                                                               *
      *****************************************************************
     C     SRAJAcM       BEGSR
 
      ** Check first if the record exists.
 
     C                   EVAL      KJANo = A_JANO
     C                   EVAL      KCust = A_CUST
     C                   EVAL      KNAHo = A_NAHO
 
     C     KJAC9         CHAIN     SDJACCL9
 
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDJACCPD'
     C                   EVAL      DBKey = A_JANO + A_CUST + A_NAHO
     C                   EVAL      DBase = 104
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update 'Before Image'.
 
     C                   MOVEL(P)  SDJACM        B_JAcM
 
     C                   EVAL      JCINVP = A_INVP
     C                   EVAL      JCPAHT = A_PAHT
     C                   EVAL      JCPAHO = A_PAHO
     C                   EVAL      JCCHTP = A_CHTP
     C                   EVAL      JCLCDT = BJRDNB
     C                   EVAL      JCFRNT = A_FRNT                                            232543
     C                   EVAL      JCREPA = A_REPA                                            232543
 
      ** Get timestamp.
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PZTmst
 
     C                   EVAL      JCTMST = PZTmst
 
     C                   UPDATE    SDJACCD0
 
     C                   IF        CSD092 = 'Y'                                               CSD092
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      JCJANO        PCUST                                        CSD092
     C                   PARM      *BLANKS       PBefCUST                                     CSD092
     C                   PARM      *BLANKS       PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      *BLANKS       PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                   MD026854
     C                   PARM      *BLANKS       PAftFTCS                                   MD026854
     C                   PARM      B_JACM        PBefJACC                                     CSD092
     C                   PARM      SDJACM        PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                      MD026854
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDJAcM - Deletes Joint A/c Member details.                  *
      *                                                               *
      *****************************************************************
     C     SRDJAcM       BEGSR
 
      ** Check first if the record exists.
 
     C                   EVAL      KJANo = A_JANO
     C                   EVAL      KCust = A_CUST
     C                   EVAL      KNAHo = A_NAHO
 
     C     KJAC9         CHAIN     SDJACCL9
 
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDJACCPD'
     C                   EVAL      DBKey = A_JANO + A_CUST + A_NAHO
     C                   EVAL      DBase = 105
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update 'Before Image'.
 
     C                   MOVEL(P)  SDJACM        B_JAcM
 
     C                   DELETE    SDJACCD0
 
     C                   IF        CSD092 = 'Y'                                               CSD092
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      JCJANO        PCUST                                        CSD092
     C                   PARM      *BLANKS       PBefCUST                                     CSD092
     C                   PARM      *BLANKS       PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      *BLANKS       PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                   MD026854
     C                   PARM      *BLANKS       PAftFTCS                                   MD026854
     C                   PARM      B_JACM        PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                      MD026854
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkWksUpd - Checks for updates by another workstation.     *
      *                                                               *
      *****************************************************************
     C     SRChkWksUpd   BEGSR
 
      ** Retrieve current Joint A/c Member details.
 
     C                   EXSR      SRJAcMRtv
 
      ** If timestamps are not the same, then the record has been updated
      ** by another workstation.
 
      ** Processing varies according to the mode the program is running in.
      ** In interacive mode, simply check whether the timestamp field
      ** has been updated since the original Joint A/c Member detail was
      ** fetched by this program.
      ** In batch mode, check return parameters from the RTV module for
      ** errors and send messages (if necessesary) to the system operator.
 
      ** Interactive Mode
 
     C                   IF        PZType = '1'
 
     C                   IF        A_TMST <> C_TMST
     C                   EVAL      PRetCode = '*RECUPD   '
     C                   ENDIF
 
      ** Batch Mode
 
     C                   ELSE
 
     C                   IF        OKACTN = 'N' OR
     C                             OKCUST = 'N' OR
     C                             OKNAHO = 'N'
     C                   EVAL      PRetCode = '*RECUPD   '
 
     C                   EVAL      WI = 1
 
     C                   DOW       WI < ArrayMax AND
     C                             FldNameArr(WI) <> *BLANKS
 
     C                   EVAL      PZDBErr = 'Update Error: ' + A_FRNT
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM      *BLANKS       PZRtCd
     C                   PARM                    PZDBErr
     C                   PARM                    PZMsgID
     C                   PARM                    PZMsgF
 
     C                   EVAL      WI = WI + 1
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFCTL - Updates Standing Data Controls.                     *
      *                                                               *
      *****************************************************************
     C     SRFCTL        BEGSR
 
     C                   EVAL      KFLNM = 'SDJACCPD'
     C     KFLNM         CHAIN     SDFCTLL0
 
     C                   IF        %FOUND
 
     C                   SELECT
 
     C                   WHEN      A_CHTP = 'I'
     C                   EVAL      AHNORC = AHNORC + 1
     C                   EVAL      AHNOIN = AHNOIN + 1
 
     C                   WHEN      A_CHTP = 'A'
     C                   EVAL      AHNOAM = AHNOAM + 1
 
     C                   WHEN      A_CHTP = 'D'
     C                   EVAL      AHNORC = AHNORC - 1
     C                   EVAL      AHNODL = AHNODL + 1
 
     C                   ENDSL
 
     C                   UPDATE    SDFCTLD0
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBKey = KFLNM
     C                   EVAL      DBase = 106
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR24x7 - Runs 24x7 processing.                               *
      *                                                               *
      *****************************************************************
     C     SR24x7        BEGSR
 
     C                   EXSR      SRJAcMLog
 
     C                   IF        PRetCodeOut = *BLANKS
 
     C                   EVAL      APTGTTYPE = 'SDJACM'
     C                   EVAL      APFOTRANID = JCFRNT
     C                   EVAL      APRPRLOCN = JCREPA
     C                   EVAL      APUSERID = PSUser
     C                   EVAL      APMIDUSR = PSUser
 
     C                   IF        JCCUST <> *BLANKS
     C                   EVAL      PKey = JCJANO + JCCUST
     C                   ELSE
     C                   EVAL      PKey = JCJANO + JCNAHO
     C                   ENDIF
 
      ** Log this Joint A/c Member.
 
     C                   CALLB     'APLOGTRAN'
      **                 *********************
 
     C                   PARM      *BLANKS       PRetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       PTimestamp
     C                   PARM                    PKey
     C                   PARM      *BLANKS       PAKey
 
     C                   ENDIF
 
     C                   IF        PRetCodeOut <> *BLANKS
     C                   EVAL      PRetCode = '*APLOG    '
     C                   RETURN
     C                   ENDIF
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcMRtv - Joint A/c Member Details Retrieve.               *
      *                                                               *
      *****************************************************************
     C     SRJAcMRtv     BEGSR
 
      ** 'I' & 'A' are possible default 2nd screen Action Codes.
 
     C                   IF        A_CHTP = 'I' OR
     C                             A_CHTP = 'A'
     C                   EVAL      PDACTD = 'Y'
     C                   ELSE
     C                   EVAL      PDACTD = 'N'
     C                   ENDIF
 
     C                   CLEAR                   JAcMChkFmt
 
     C                   CALLB     'SDJACMRTV'
      **                 *********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Operation Mode
     C                   PARM      *BLANK        POprMode
 
      ** Response Mode
     C                   PARM      *BLANK        PResMode
 
      ** Action Code
     C                   PARM      A_CHTP        PDACTN
 
      ** Front Office Transaction ID
     C                   PARM      A_FRNT        PDFRNT
 
      ** Joint A/c Number
     C                   PARM      A_JANO        PDJANO
 
      ** Customer Number
     C                   PARM      A_CUST        PDCUST
 
      ** Non-a/c Holder
     C                   PARM      A_NAHO        PDNAHO
 
      ** Action Code Default
     C                   PARM                    PDACTD
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Joint A/c Member Details - Timestamp Check
     C                   PARM                    JAcMChkFmt
 
      ** OK - Action Code
     C                   PARM      'Y'           OKACTN
 
      ** OK - Customer Number
     C                   PARM      'Y'           OKCUST
 
      ** OK - Non-a/c Holder
     C                   PARM      'Y'           OKNAHO
 
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
 
      ** Array Index (3P0) From/To Caller
     C                   PARM      *ZERO         Ix
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcMLog - Joint A/c Member Details Log.                    *
      *                                                               *
      *****************************************************************
     C     SRJAcMLog     BEGSR
 
     C                   CALLB     'SDJACMLOG'
      **                 *********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCodeOut
 
      ** Joint A/c Member Details - File Format
     C                   PARM                    SDJACM
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Transaction Details
     C                   PARM                    TRANSDTL
 
     C                   ENDSR
      *****************************************************************                     BUG23732
      /EJECT                                                                                BUG23732
      *****************************************************************                     BUG23732
      *                                                               *                     BUG23732
      *  SRWrHiFl - Subroutine to write Details in History Files      *                     BUG23732
      *                                                               *                     BUG23732
      *  Called by: MAIN                                              *                     BUG23732
      *                                                               *                     BUG23732
      *  Calls: SRWrCuSt                                              *                     BUG23732
      *                                                               *                     BUG23732
      *****************************************************************                     BUG23732
      *                                                                                     BUG23732
     C     SRWrHiFl      BEGSR                                                              BUG23732
      *                                                                                     BUG23732
      ** For Customer                                                                       BUG23732
      *                                                                                     BUG23732
     C                   IF        A_JANO <> *BLANKS                                        BUG23732
     C                   EVAL      PCust = A_CUST                                           BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOCUSTR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM                    PCust                                      BUG23732
     C                   PARM      *BLANKS       PKySt                                      BUG23732
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBKEY = PCust                                            BUG23732
     C                   EVAL      DBFILE = 'SDCUSTPD'                                      BUG23732
     C                   EVAL      DBASE = 108                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOBRCHR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM      BBBRCD        PBrca                                      BUG23732
     C     SDBRCH        PARM      SDBRCH        DSFDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBKEY =  BBBRCD                                          BUG23732
     C                   EVAL      DBFILE = 'SDBRCHPD'                                      BUG23732
     C                   EVAL      DBASE = 109                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOLOCNR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM      A8LCCD        PLocn                                      BUG23732
     C     SDLOCN        PARM      SDLOCN        DSFDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBKEY = A8LCCD                                           BUG23732
     C                   EVAL      DBFILE = 'SDLOCNPD'                                      BUG23732
     C                   EVAL      DBASE = 110                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
      ** Chain Customer Details by Country of Tax File to get                               BUG23732
      ** the European Tax Status                                                            BUG23732
      *                                                                                     BUG23732
     C                   EVAL      KCust = A_CUST                                           BUG23732
     C                   EVAL      KCtax = DVCNCD                                           BUG23732
      *                                                                                     BUG23732
     C     KCustByTax    CHAIN     SDACTXL1                                                 BUG23732
      *                                                                                     BUG23732
      ** No Record Found                                                                    BUG23732
      *                                                                                     BUG23732
     C                   IF        NOT %FOUND(SDACTXL1)                                     BUG23732
     C                   EVAL      AXETXS = *BLANKS                                         BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
      ** Get the Tax Status                                                                 BUG23732
      *                                                                                     BUG23732
     C                   IF        AXETXS = 'S' OR                                          BUG23732
     C                             AXETXS = 'D' OR                                          BUG23732
     C                             AXETXS = 'Y' AND                                           CER069
     C                             CER069 = 'Y' OR                                            CER069
     C                             AXETXS = 'T'                                             BUG23732
      *                                                                                     BUG23732
     C                   EXSR      SRWrCuSt                                                 BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDSR                                                              BUG23732
      *****************************************************************                     BUG23732
      /EJECT                                                                                BUG23732
      *****************************************************************                     BUG23732
      *                                                               *                     BUG23732
      *  SRWrCuSt - Subroutine to write Details in SDINPHPD file and  *                     BUG23732
      *             SDTHRHPD file for Customer                        *                     BUG23732
      *                                                               *                     BUG23732
      *  Called by: MAIN                                              *                     BUG23732
      *                                                               *                     BUG23732
      *  Calls: None                                                  *                     BUG23732
      *                                                               *                     BUG23732
      *****************************************************************                     BUG23732
      *                                                                                     BUG23732
     C     SRWrCuSt      BEGSR                                                              BUG23732
      *                                                                                     BUG23732
     C                   EVAL      PCustT = A_CUST                                          BUG23732
     C     PCustT        CHAIN     SDINPHL0                                                 BUG23732
     C                   IF        NOT %FOUND(SDINPHL0)                                     BUG23732
     C                   EVAL      TIBRCA = BBBRCD                                          BUG23732
     C                   EVAL      TIJOIN = A_JANO                                          BUG23732
     C                   EVAL      TICUST = PCustT                                          BUG23732
     C                   EVAL      TILSSD = *ZEROS                                          BUG23732
     C                   EVAL      TIPGNO = *ZEROS                                          BUG23732
     C                   EVAL      TISTRQ = *BLANKS                                         BUG23732
     C                   EVAL      TIUTTH = *ZEROS                                          BUG23732
     C                   EVAL      TIGSIN = *ZEROS                                          BUG23732
     C                   EVAL      TITTAX = *ZEROS                                          BUG23732
     C                   EVAL      TICUTH = E5EXTH                                          BUG23732
     C                   WRITE     SDINPHD0                                                 BUG23732
      *                                                                                     BUG23732
     C                   IF        TICUTH <> *ZEROS                                         BUG23732
      *                                                                                     BUG23732
     C     PCustT        CHAIN     SDTHRHL3                                                 BUG23732
     C                   IF        NOT %FOUND(SDTHRHL3)                                     BUG23732
      *                                                                                     BUG23732
     C                   EVAL      TECUST = PCustT                                          BUG23732
     C                   EVAL      TEACTD = BJRDNB                                          BUG23732
     C                   EVAL      TECEXT = TICUTH                                          BUG23732
     C                   EVAL      TETRAD = E5EADT                                          BUG23732
     C                   EVAL      TETRVD = E5EVDT                                          BUG23732
     C                   EVAL      TETRMD = E5ETXT                                          BUG23732
     C                   WRITE     SDTHRHD0                                                 BUG23732
      *                                                                                     BUG23732
     C                   ELSE                                                               BUG23732
      *                                                                                     BUG23732
     C                   IF        TEACTD = BJRDNB                                          BUG23732
      *                                                                                     BUG23732
     C                   EVAL      TECEXT = TICUTH                                          BUG23732
     C                   EVAL      TETRAD = E5EADT                                          BUG23732
     C                   EVAL      TETRVD = E5EVDT                                          BUG23732
     C                   EVAL      TETRMD = E5ETXT                                          BUG23732
     C                   UPDATE    SDTHRHD0                                                 BUG23732
      *                                                                                     BUG23732
     C                   ELSE                                                               BUG23732
     C                   EVAL      TECUST = PCustT                                          BUG23732
     C                   EVAL      TEACTD = BJRDNB                                          BUG23732
     C                   EVAL      TECEXT = TICUTH                                          BUG23732
     C                   EVAL      TETRAD = E5EADT                                          BUG23732
     C                   EVAL      TETRVD = E5EVDT                                          BUG23732
     C                   EVAL      TETRMD = E5ETXT                                          BUG23732
     C                   WRITE     SDTHRHD0                                                 BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ELSE                                                               BUG23732
      *                                                                                     BUG23732
     C                   EVAL      TIJOIN = A_JANO                                          BUG23732
     C                   UPDATE    SDINPHD0                                                 BUG23732
      *                                                                                     BUG23732
     C                   IF        TICUTH <> *ZEROS                                         BUG23732
      *                                                                                     BUG23732
     C     PCustT        CHAIN     SDTHRHL3                                                 BUG23732
     C                   IF        NOT %FOUND(SDTHRHL3)                                     BUG23732
      *                                                                                     BUG23732
     C                   EVAL      TECUST = PCustT                                          BUG23732
     C                   EVAL      TEACTD = BJRDNB                                          BUG23732
     C                   EVAL      TECEXT = TICUTH                                          BUG23732
     C                   EVAL      TETRAD = E5EADT                                          BUG23732
     C                   EVAL      TETRVD = E5EVDT                                          BUG23732
     C                   EVAL      TETRMD = E5ETXT                                          BUG23732
     C                   WRITE     SDTHRHD0                                                 BUG23732
      *                                                                                     BUG23732
     C                   ELSE                                                               BUG23732
      *                                                                                     BUG23732
     C                   IF        TEACTD = BJRDNB                                          BUG23732
      *                                                                                     BUG23732
     C                   EVAL      TECEXT = TICUTH                                          BUG23732
     C                   EVAL      TETRAD = E5EADT                                          BUG23732
     C                   EVAL      TETRVD = E5EVDT                                          BUG23732
     C                   EVAL      TETRMD = E5ETXT                                          BUG23732
     C                   UPDATE    SDTHRHD0                                                 BUG23732
      *                                                                                     BUG23732
     C                   ELSE                                                               BUG23732
      *                                                                                     BUG23732
     C                   EVAL      TECUST = PCustT                                          BUG23732
     C                   EVAL      TEACTD = BJRDNB                                          BUG23732
     C                   EVAL      TECEXT = TICUTH                                          BUG23732
     C                   EVAL      TETRAD = E5EADT                                          BUG23732
     C                   EVAL      TETRVD = E5EVDT                                          BUG23732
     C                   EVAL      TETRMD = E5ETXT                                          BUG23732
     C                   WRITE     SDTHRHD0                                                 BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDSR                                                              BUG23732
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Override SDFTNHL0                                                                   MD027576
     C                   Z-ADD     50            CMDLEN           15 5                      MD027576
     C                   CALL      'QCMDEXC'                                                MD027576
     C                   PARM                    CMDNH                                      MD027576
     C                   PARM                    CMDLEN                                     MD027576
      * Override SDFTCSL0                                                                   MD027576
     C                   CALL      'QCMDEXC'                                                MD027576
     C                   PARM                    CMDCS                                      MD027576
     C                   PARM                    CMDLEN                                     MD027576
                                                                                            MD027576
     C     *ENTRY        PLIST
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM                    PRetCode
 
      ** Valid Joint A/c Member Details
     C                   PARM                    SDVJACM
 
      ** Key Lists
 
     C     KJAC9         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KCust
     C                   KFLD                    KNAHo
 
     C     KCustByTax    KLIST                                                              BUG23732
     C                   KFLD                    KCust                                      BUG23732
     C                   KFLD                    KCtax                                      BUG23732
      ** Get bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC011 is enabled.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = PSARD
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CSD092
      ** Check if CSD092 is enabled.                                                          CSD092
                                                                                              CSD092
     C                   EVAL      CSD092 = 'N'                                               CSD092
     C                   CALL      'AOSARDR0'                                                 CSD092
     C                   PARM      *BLANKS       PRtCd                                        CSD092
     C                   PARM      '*VERIFY'     POptn                                        CSD092
     C                   PARM      'CSD092'      PSARD                                        CSD092
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD092
                                                                                              CSD092
     C                   IF        PRtCd = *BLANKS                                            CSD092
     C                   EVAL      CSD092 = 'Y'                                               CSD092
     C                   ELSE                                                                 CSD092
                                                                                              CSD092
     C                   IF        PRtCd <> '*NRF   '                                         CSD092
     C     *LOCK         IN        LDA                                                        CSD092
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD092
     C                   EVAL      DBKey = PSARD                                              CSD092
     C                   EVAL      DBase = 107                                                CSD092
     C                   OUT       LDA                                                        CSD092
     C                   EXSR      *PSSR                                                      CSD092
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
     C                   ENDIF                                                                CSD092
 
      ** Determine whether the program is running interactively (PZType = '1')
      ** or in batch (PZType = '0').
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PZRtrn
     C                   PARM      *BLANK        PZType
 
      ** Allow access to Joint A/c Members by Front Office ID when in RPR
      ** mode for inserts. Set RTV module parameter POprMode to '*FRONT'
      ** if the program  1. is running in interactive mode.
      **                 2. has a Last Change Type equal to 'I'.
      **                 3. has a Front Office ID.
 
     C                   IF        PZType = '1' AND
     C                             A_CHTP = 'I' AND
     C                             A_FRNT <> *BLANKS
     C                   EVAL      POprMode = '*FRONT'
     C                   ELSE
 
      ** Use Front Office ID if running in batch mode for inserts. Use
      ** Joint A/c Number otherwise.
 
     C                   IF        PZType = '0' AND
     C                             A_CHTP = 'I'
     C                   EVAL      POprMode = '*FRONT'
     C                   ELSE
     C                   EVAL      POprMode = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IN        SC24X7
      *                                                                                     BUG23732
      ** Check if CER048 is enabled.                                                        BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOSARDR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*VERIFY'     POptn                                      BUG23732
     C                   PARM      'CER048'      PSard                                      BUG23732
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23732
      *                                                                                     BUG23732
     C                   EVAL      CER048 = 'N'                                             BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd = *BLANKS                                          BUG23732
      *                                                                                     BUG23732
     C                   EVAL      CER048 = 'Y'                                             BUG23732
      *                                                                                     BUG23732
     C                   ELSE                                                               BUG23732
      *                                                                                     BUG23732
     C                   IF        (PRtcd <> *BLANKS) AND                                   BUG23732
     C                             (PRtcd <> '*NRF   ')                                     BUG23732
      *                                                                                     BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG23732
     C                   EVAL      DBKEY = 'CER048'                                         BUG23732
     C                   EVAL      DBASE = 111                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
                                                                                              CER069
      ** Check if CER069 is enabled.                                                          CER069
                                                                                              CER069
     C                   CALL      'AOSARDR0'                                                 CER069
     C                   PARM      *BLANKS       PRtcd                                        CER069
     C                   PARM      '*VERIFY'     POptn                                        CER069
     C                   PARM      'CER069'      PSard                                        CER069
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
      *                                                                                       CER069
     C                   EVAL      CER069 = 'N'                                               CER069
      *                                                                                       CER069
     C                   IF        PRtcd = *BLANKS                                            CER069
      *                                                                                       CER069
     C                   EVAL      CER069 = 'Y'                                               CER069
      *                                                                                       CER069
     C                   ELSE                                                                 CER069
      *                                                                                       CER069
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER069
     C                             (PRtcd <> '*NRF   ')                                       CER069
      *                                                                                       CER069
     C     *LOCK         IN        LDA                                                        CER069
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER069
     C                   EVAL      DBKEY = 'CER069'                                           CER069
     C                   EVAL      DBASE = 112                                                CER069
     C                   OUT       LDA                                                        CER069
     C                   EXSR      *PSSR                                                      CER069
      *                                                                                       CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   ENDIF                                                                CER069
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** ILE RPG Program Status Subroutine
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
** CMDNH                                                                                    MD027576
OVRDBF FILE(SDFTNHL0) TOFILE(SDFTNHL0) SHARE(*NO)                                           MD027576
** CMDCS                                                                                    MD027576
OVRDBF FILE(SDFTCSL0) TOFILE(SDFTCSL0) SHARE(*NO)                                           MD027576
