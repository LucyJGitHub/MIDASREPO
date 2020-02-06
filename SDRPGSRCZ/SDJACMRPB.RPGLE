     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Repair Browse')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACMRPB - Midas SD Joint Account Member Details Repair     *
      *              Browse                                           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24029           Date 20May09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 01Apr05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDJACMRDF CF   E             WORKSTN SFILE(SDJACMRS1:WSFRN)
      ** Midas SD Joint A/c Member Details Repair Display File
 
     FSDIJACML0 IF   E           K DISK    INFSR(*PSSR)
 
     FSDIJACML1 UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(SDIJACMD0:SDIJACMD1)
 
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Indicator Array Overlay Data Structure
     D INPTR           S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(INPTR)
 
      ** Function Key Indicators
     D  F03                   03     03
     D  F12                   12     12
 
      ** Subfile Management Indicators
     D  SFLCLR                91     91
     D  SFLDSP                92     92
     D  SFLEND                93     93
     D  ROLLUP                94     94
     D  SFLNXTCHG             95     95
     D  SFLMSGEND             96     96
 
      ** Invalid Joint A/c Member Details Data Structure
     D SDIJACM       E DS                  EXTNAME(SDIJACMPD)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Non-a/c Holder Details Data Structure
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            BUG24029
      ** Long Access Object Data Structure                                                  BUG24029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24029
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S             10A
     D PSFACT          S              8A
     D PMSGID          S              7A
     D POPSEL          S              1A
     D PACTNSEL        S              1A
     D PFOIDSEL        S             20A
     D PJASEL          S              6A
     D PCUSEL          S              6A
     D PNASEL          S             10A
     D PDTMST          S               Z
 
      ** API Parameters
     D PDASOC          S             20A
     D PDBRSN          S              3A
     D PINKC           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PInvF1          S             10A
     D PInvF2          S             10A
     D PInvF3          S             10A
     D PInFD1          S           4000A
     D PInFD2          S           4000A
     D PInFD3          S           4000A
     D PDNAR1          S             30A
     D PDFLD1          S             35A
     D PDNAR2          S             30A
     D PDFLD2          S             35A
     D PDNAR3          S             30A
     D PDFLD3          S             35A
     D PDNAR4          S             30A
     D PDFLD4          S             35A
     D PDNAR5          S             30A
     D PDFLD5          S             35A
     D PDNAR6          S             30A
     D PDFLD6          S             35A
     D PDNAR7          S             30A
     D PDFLD7          S             35A
     D PDNAR8          S             30A
     D PDFLD8          S             35A
     D PDNAR9          S             30A
     D PDFLD9          S             35A
     D PDTMSP          S             26A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PKyst           S              7A
     D PNAHo           S             10A
 
      ** Standard Utility Parameters
     D PZMsgF          S             10A
     D PZMsgID         S             10A
     D PMsgDNb         S              7A
     D PMsgNm          S             10A
     D PMsgTxt         S             80A
 
      ** Parameter for RPC1600
     D EntryData       S           3000A
     D FileName        S             10A
 
      ** Key Fields
     D KTmst           S                   LIKE(DDTMST)
     D KFrnt           S                   LIKE(DDFRNT)
 
      ** Working Variables
     D WSFRN           S              5P 0
     D WRecCnt         S              3P 0
     D WEoF            S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   SELECT
 
      ** Build the subfile.
 
     C                   WHEN      PSFACT = '*BUILD  '
     C                   EXSR      SRBldSfl
 
      ** Read the subfile.
 
     C                   WHEN      PSFACT = '*READ   '
     C                   EXSR      SRRedSfl
 
     C                   ENDSL
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Builds the Joint A/c Member details subfile.      *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      DDSFRN = *ZERO
     C                   EVAL      WSFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
 
      ** Clear the subfile.
 
     C                   EXSR      SRClrSfl
 
      ** Send error message if necessary.
 
     C                   IF        PMSGID <> *BLANKS
     C                   EVAL      PZMsgID = PMSGID
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     SDIJACML0
 
     C                   EVAL      ROLLUP = *ON
 
     C                   DOW       ROLLUP = *ON
 
      ** Read an invalid Joint A/c Member detail.
 
     C                   EXSR      SRRdIJAcMDt
 
     C                   EVAL      WRecCnt = *ZERO
 
     C                   DOW       WEoF  <> 'Y'
 
     C                   EVAL      WSFRN = DDSFRN
     C                   EVAL      WSFRN = WSFRN + 1
     C                   EVAL      WRecCnt = WRecCnt + 1
 
     C                   EVAL      DDOPTN = *BLANK
     C                   EVAL      DDSFRN = WSFRN
 
     C                   WRITE     SDJACMRS1
 
      ** Leave if one subfile page has been filled.
 
     C                   IF        WRecCnt = 14
 
      ** Check first if there are more records available.
 
     C                   EXSR      SRRdIJAcMDt
 
     C                   IF        WEoF <> 'Y'
     C                   READP     SDIJACML0
     C                   ENDIF
 
     C                   LEAVE
     C                   ENDIF
 
     C                   EXSR      SRRdIJAcMDt
     C                   ENDDO
 
     C                   IF        WEoF = 'Y' AND
     C                             WRecCnt = *ZERO
 
      ** No records found.
 
     C                   EXFMT     SDJACMRF1
     C                   EVAL      PINKC = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   EXSR      SRDSfPag
 
     C                   IF        F03 = *ON
     C                   EVAL      PINKC = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDSfPag - Displays the subfile page.                        *
      *                                                               *
      *****************************************************************
     C     SRDSfPag      BEGSR
 
     C                   WRITE     SDJACMRF2
     C                   WRITE     SDJACMRC2
     C                   WRITE     SDJACMRC1
     C                   READ      SDJACMRC1
 
      ** Clear messages from the program message queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRedSfl - Reads the subfile.                                *
      *                                                               *
      *****************************************************************
     C     SRRedSfl      BEGSR
 
     C                   EVAL      POPSEL = *BLANK
     C                   EVAL      PACTNSEL = *BLANK
     C                   EVAL      PFOIDSEL = *BLANKS
     C                   EVAL      PJASEL = *BLANKS
     C                   EVAL      PCUSEL = *BLANKS
     C                   EVAL      PNASEL = *BLANKS
     C                   CLEAR                   PDTMST
 
     C                   READC     SDJACMRS1
 
     C                   DOW       NOT %EOF
 
     C                   IF        DDOPTN <> *BLANKS
 
      ** Validate repair Option.
 
     C                   EXSR      SRValOpt
 
     C                   SELECT
 
     C                   WHEN      DDOPTN = 'E'
     C                   EXSR      SREnqInv
 
     C                   WHEN      DDOPTN = 'Q'
     C                   EXSR      SRPrmDel
 
     C                   OTHER
 
      ** Return the Option, Action Code, Front Office ID, Joint A/c Number,
      ** Customer Number, & Non-a/c Holder.
 
     C                   EVAL      POPSEL = DDOPTN
     C                   EVAL      PACTNSEL = DDACTN
     C                   EVAL      PFOIDSEL = DDFRNT
     C                   EVAL      PJASEL = DDJANO
     C                   EVAL      PCUSEL = DDCUST
     C                   EVAL      PNASEL = DDNAHO
     C                   EVAL      PDTMST = DDTMST
     C                   LEAVESR
     C                   ENDSL
 
     C                   ENDIF
 
     C                   READC     SDJACMRS1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValOpt - Validates the Option.                             *
      *                                                               *
      *****************************************************************
     C     SRValOpt      BEGSR
 
     C                   CALLB     'ZAROPTVAL'
      **                 *********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Option code
     C                   PARM                    DDOPTN
 
      ** Front Office ID
     C                   PARM                    DDFRNT
 
      ** Booking Branch
     C                   PARM                    PDBRSN
 
      ** ICD Single Branch Code
     C                   PARM                    BJSBRC
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Function Keys
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKL
 
     C                   IF        PINKC = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   IF        PINKL = *ON
     C                   EVAL      DDOPTN = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnqInv - Enquires on invalid transactions.                 *
      *                                                               *
      *****************************************************************
     C     SREnqInv      BEGSR
 
     C                   EVAL      KTmst = DDTMST
     C                   EVAL      KFrnt = DDFRNT
     C     KIJL0         CHAIN     SDIJACML0
 
     C                   MOVE      DDTMST        PDTMSP
 
     C                   CALLB     'ZAINVTRENQ'
      **                 **********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Action code
     C                   PARM                    DDACTN
 
      ** Front Office ID
     C                   PARM                    DDFRNT
 
      ** Associated Front Office ID
     C                   PARM                    PDASOC
 
      ** Timestamp
     C                   PARM                    PDTMSP
 
      ** Invalid File Names
     C                   PARM      'SDIJACMPD'   PInvF1
     C                   PARM      *BLANKS       PInvF2
     C                   PARM      *BLANKS       PInvF3
     C                   PARM      *BLANKS       PInvF4           10                        MD041294
 
      ** Invalid File Data
     C                   PARM      SDIJACM       PInFD1
     C                   PARM      *BLANKS       PInFD2
     C                   PARM      *BLANKS       PInFD3
     C                   PARM      *BLANKS       PInFD4         4000                        MD041294
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Function Keys
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKL
 
     C                   IF        PINKC = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrmDel - Prompts for deletion.                             *
      *                                                               *
      *****************************************************************
     C     SRPrmDel      BEGSR
 
     C                   CALLB     'ZAINVTRDEL'
      **                 **********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Action Code
     C                   PARM                    DDACTN
 
      ** Front Office ID & Associated Front Office ID
     C                   PARM                    DDFRNT
     C                   PARM                    PDASOC
 
      ** Timestamp
     C                   PARM                    DDTMST
 
      ** Narrative & Field Content 1 - 9
     C                   PARM                    PDNAR1
     C                   PARM      DDJANO        PDFLD1
     C                   PARM                    PDNAR2
     C                   PARM      DDCUST        PDFLD2
     C                   PARM                    PDNAR3
     C                   PARM      DDNAHO        PDFLD3
     C                   PARM                    PDNAR4
     C                   PARM                    PDFLD4
     C                   PARM                    PDNAR5
     C                   PARM                    PDFLD5
     C                   PARM                    PDNAR6
     C                   PARM                    PDFLD6
     C                   PARM                    PDNAR7
     C                   PARM                    PDFLD7
     C                   PARM                    PDNAR8
     C                   PARM                    PDFLD8
     C                   PARM                    PDNAR9
     C                   PARM                    PDFLD9
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Function Keys
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKJ
     C                   PARM      *OFF          PINKL
 
     C                   IF        PINKC = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Delete invalid Joint A/c Member on F10.
 
     C                   IF        PINKJ = *ON
 
     C                   EVAL      KTmst = DDTMST
     C                   EVAL      KFrnt = DDFRNT
     C     KIJL1         CHAIN     SDIJACML1
 
     C                   IF        %FOUND
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     *BLANKS       EntryData
     C                   MOVEL     *BLANKS       FileName
     C                   CALL      'RPC1600'
     C                   PARM      SDIJACM       EntryData
     C                   PARM      'SDIJACMPD'   FileName
     C                   DELETE    SDIJACML1
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdIJAcMDt - Reads an invalid Joint Account Member detail.  *
      *                                                               *
      *****************************************************************
     C     SRRdIJAcMDt   BEGSR
 
     C                   EVAL      WEoF = 'N'
     C                   EVAL      SFLEND = *OFF
 
     C                   READ      SDIJACML0
 
     C                   IF        NOT %EOF
 
     C                   IF        DDCUST <> *BLANKS
     C                   EVAL      PCust = DDCUST
     C                   EXSR      SRGetCust
     C                   ELSE
     C                   EVAL      PNAHo = DDNAHO
     C                   EXSR      SRGetNAHo
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      WEoF = 'Y'
     C                   EVAL      SFLEND = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSfl - Clears the subfile.                               *
      *                                                               *
      *****************************************************************
     C     SRClrSfl      BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SDJACMRC1
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCust - Gets customer details.                           *
      *                                                               *
      *****************************************************************
     C     SRGetCust     BEGSR
 
     C                   CLEAR                   SDCUST
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey = PCust
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetNAHo - Gets Non-a/c Holder details.                     *
      *                                                               *
      *****************************************************************
     C     SRGetNAHo     BEGSR
 
     C                   CLEAR                   SDNAHO
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PNAHo
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDNAHOPD'
     C                   EVAL      DBKey = PNAHo
     C                   EVAL      DBase = 103
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvTxt - Retrieves text out of message IDs.                *
      *                                                               *
      *****************************************************************
     C     SRRtvTxt      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMsgDNb
     C                   PARM      'ZZGBMSGF  '  PMsgNm
     C                   PARM      *BLANKS       PMsgTxt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Sends error messages to the program message       *
      *             queue.                                            *
      *                                                               *
      *****************************************************************
     C     SRSndErr      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM      'SDUSRMSG  '  PZMsgF
     C                   PARM                    PZMsgID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Subfile Action
     C                   PARM                    PSFACT
 
      ** Message ID
     C                   PARM                    PMSGID
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Option Selected
     C                   PARM                    POPSEL
 
      ** Action Code Selected
     C                   PARM                    PACTNSEL
 
      ** Front Office ID Selected
     C                   PARM                    PFOIDSEL
 
      ** Joint A/c Number Selected
     C                   PARM                    PJASEL
 
      ** Customer Number Selected
     C                   PARM                    PCUSEL
 
      ** Non-a/c Holder Selected
     C                   PARM                    PNASEL
 
      ** Joint A/c Member Timestamp
     C                   PARM                    PDTMST
 
      ** Command Keys
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
      ** Key Lists
 
     C     KIJL0         KLIST
     C                   KFLD                    KTmst
     C                   KFLD                    KFrnt
 
     C     KIJL1         KLIST
     C                   KFLD                    KFrnt
     C                   KFLD                    KTmst
 
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
 
      ** Set the system information display fields.
 
     C                   EVAL      DDRUND = BJMRDT
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWSID = PsJobName
     C                   EVAL      DDPGMQ = PSProcMod
 
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLMSGEND = *ON
 
      **---------------------------------------------------------------
      ** Program, Module, & Procedure Names for DB Error Processing
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
      ** Format text for invalid transaction deletion function.
 
     C                   EVAL      PMsgDNb = 'APA0402'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDNAR1 = PMsgTxt
 
     C                   EVAL      PMsgDNb = 'APA0403'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDNAR2 = PMsgTxt
 
     C                   EVAL      PMsgDNb = 'APA0404'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDNAR3 = PMsgTxt
 
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
