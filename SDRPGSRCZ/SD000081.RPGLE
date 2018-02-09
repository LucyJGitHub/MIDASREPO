     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Centralised Static Data maintenance')         *
/*OVR *: OVRDBF FILE(SD000081AC) TOFILE(SDACODPD)                     *
/*OVR *: OVRDBF FILE(SD000081CS) TOFILE(SDCUSTPD)                     *
/*OVR *: OVRDBF FILE(SD000081CR) TOFILE(SDCURRPD)                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000081 - Centralised Static Data maintenance               *
      *                                                               *
      *  Function:  This module selects the default zone, replaces    *
      *             the central data with data from the default zone, *
      *             and cascades the new central data down to the     *
      *             zones.                                            *
      *                                                               *
      *  Component of: None.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE164             Date 18Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER049             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CER059 - German Feature Upgrade to Delhi (Recompile)         *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    22         Screen 2 Action error                           *
      *    40         Toggles the footer text                         *
      *               On: show 1=select                               *
      *               Off: hide 1=select                              *
      *    41         Show Default Zone subfile column                *
      *    42         Show F12                                        *
      *    45         Show subfile                                    *
      *    46         Clear subfile records                           *
      *    47         SFLNXTCHG for the subfile                       *
      *    48         Show subfile control                            *
      *    49         Toggles 2nd line of the heading                 *
      *               Off: 'Default Zone selection'                   *
      *               On: 'Cascade to Zones'                          *
      *    50         General-purpose                                 *
      *    51         General-purpose                                 *
      *    52         General-purpose                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSD000081DFCF   E             WORKSTN
     F                                     SFILE(SD000081S0:S0SFRRN)
     F                                     SFILE(SD000081S1:S1SFRRN)
 
     FGPZONEL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Zone files
      ** --------------------------------------------------------------
 
     FSDACODPD  IF   E             DISK    INFSR(*PSSR)
     FACKEYAL   IF   E             DISK    INFSR(*PSSR)
     FFACKYD    IF   E             DISK    INFSR(*PSSR)
     FSEACKD    IF   E             DISK    INFSR(*PSSR)
     FSDCUSTPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(B)
     FSDDLSTPD  IF   E             DISK    INFSR(*PSSR)
     FFDDTSTPD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(FDDTSTPD:FDDTSTF)
     FSDFACTPD  IF   E             DISK    INFSR(*PSSR)
     FSDHOLPD   IF   E             DISK    INFSR(*PSSR)
     FSDLOANPD  IF   E             DISK    INFSR(*PSSR)
     FSDCURRPD  IF   E             DISK    INFSR(*PSSR)
     FSDNARRPD  IF   E             DISK    INFSR(*PSSR)
     FSDACOFPD  IF   E             DISK    INFSR(*PSSR)
     FSDCTRYPD  IF   E             DISK    INFSR(*PSSR)
     FSDLOCNPD  IF   E             DISK    INFSR(*PSSR)
     FSDREGNPD  IF   E             DISK    INFSR(*PSSR)
     FSDBRCHPD  IF   E             DISK    INFSR(*PSSR)
     FTABLEV4   IF   E             DISK    INFSR(*PSSR)
     FSDLENOPD  IF   E             DISK    INFSR(*PSSR)
 
      ** Central files
      ** --------------------------------------------------------------
 
     FGPACODPD  UF A E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     PREFIX(A5:2)
     FGPAKEYPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(ACKEYALF:GPAKEYF)
     F                                     USROPN
     FGPFAKYPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(FACKYDF:GPFAKYF)
     F                                     USROPN
     F                                     PREFIX(FK)
     FGPSAKYPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SEACKDF:GPSAKYF)
     F                                     USROPN
     F                                     PREFIX(SK)
     FGPCUSTPD  UF A E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     PREFIX(BBB:2)
     FGPDLSTPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDDLSTD0:GPDLSTF)
     F                                     USROPN
     FGPDTSTPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(FDDTSTPD:GPDTSTF)
     F                                     USROPN
     FGPFACTPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDFACTD0:GPFACTF)
     F                                     USROPN
     FGPHOLIPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDHOLD0:GPHOLIF)
     F                                     USROPN
     FGPLOANPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDLOAND0:GPLOANF)
     F                                     USROPN
     F                                     PREFIX(LE)
     FGPCURRPD  UF A E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     PREFIX(A6:2)
     FGPNARRPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDNARRD0:GPNARRF)
     F                                     USROPN
     FGPACOFPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDACOFD0:GPACOFF)
     F                                     USROPN
     FGPCTRYPD  UF A E             DISK    INFSR(*PSSR)
     F                                     USROPN
     FGPLOCNPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDLOCND0:GPLOCNF)
     F                                     USROPN
     FGPREGNPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDREGND0:GPREGNF)
     F                                     USROPN
     FGPBRCHPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDBRCHD0:GPBRCHF)
     F                                     USROPN
     FGPRECGPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(TABLEV4F:GPRECGF)
     F                                     USROPN
     F                                     PREFIX(RE)
     FGPLENOPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDLENOD0:GPLENOF)
     F                                     USROPN
 
      ** Temporary files containing the copied data from the default
      ** zone. Using the declared SDACODPD instead of SD000081AC limits
      ** the ability to access the SDACODPD of different zones.
      ** --------------------------------------------------------------
 
      ** Account Codes
     FSD000081ACIF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDACODD0:UTACODD0)
     F                                     USROPN
      ** Customers
     FSD000081CSIF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDCUSTD0:UTCUSTD0)
     F                                     USROPN
     F                                     PREFIX(B)
      ** Currencies
     FSD000081CRIF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDCURRD0:UTCURRD0)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D TbCmd           S            100A   DIM(1) CTDATA PERRCD(1)
      ** Compile-time array of commands
 
     D*DsGPACOD      E DS                  EXTNAME(GPACODPD)
     D*                                    PREFIX(A5:2)
     D DsGPACOD      E DS                  EXTNAME(SDZACODPD)
     D                                     PREFIX(A5:2)
     D**C_A5SRLC     E                     EXTFLD(ACSRLC)
     D**C_A5SRFC     E                     EXTFLD(ACSRFC)
     D**C_A5RPCD     E                     EXTFLD(ACRPCD)
     D**C_A5ACPR     E                     EXTFLD(ACACPR)
     D**C_A5MISU     E                     EXTFLD(ACMISU)
     D**C_A5TRDA     E                     EXTFLD(ACTRDA)
     D**C_A5TRCA     E                     EXTFLD(ACTRCA)
     D**C_A5EACC     E                     EXTFLD(ACEACC)
      ** DS for account codes
 
     D DsGPAKEY      E DS                  EXTNAME(GPAKEYPD)
      ** DS for DL account keys
 
     D DsGPFAKY      E DS                  EXTNAME(GPFAKYPD)
     D                                     PREFIX(FK)
      ** DS for FF account keys
 
     D DsGPSAKY      E DS                  EXTNAME(GPSAKYPD)
     D                                     PREFIX(SK)
      ** DS for SE account keys
 
     D*DsGPCUST      E DS                  EXTNAME(GPCUSTPD)
     D**                                   PREFIX(BBB:2)
     D DsGPCUST      E DS                  EXTNAME(SDZCUSTPD)
     D                                     PREFIX(BBB:2)
     D  C_CUCHID     E                     EXTFLD(CUCHID)
     D  C_CUCHSC     E                     EXTFLD(CUCHSC)
     D  C_CUCABA     E                     EXTFLD(CUCABA)
     D  C_CUABA2     E                     EXTFLD(CUABA2)
     D  C_CUFWCD     E                     EXTFLD(CUFWCD)
     D  C_CUDOIC     E                     EXTFLD(CUDOIC)
     D  C_CUSSDT     E                     EXTFLD(CUSSDT)
     D  C_CUDTDL     E                     EXTFLD(CUDTDL)
     D  C_CULCD      E                     EXTFLD(CULCD)
     D  C_CUDEDT     E                     EXTFLD(CUDEDT)
     D  C_CUMGTP     E                     EXTFLD(CUMGTP)
     D  C_CUEACC     E                     EXTFLD(CUEACC)
      ** DS for account codes
 
     D DsGPDLST      E DS                  EXTNAME(GPDLSTPD)
      ** DS for Sub-types
 
     D DsGPDTST      E DS                  EXTNAME(GPDTSTPD)
      ** DS for deal type/sub-types
 
     D DsGPFACT      E DS                  EXTNAME(GPFACTPD)
      ** DS for facility types
 
     D DsGPHOLI      E DS                  EXTNAME(GPHOLIPD)
      ** DS for holidays
 
     D DsGPLOAN      E DS                  EXTNAME(GPLOANPD)
     D                                     PREFIX(LE)
      ** DS for LE type/sub-types
 
     D*DsGPCURR      E DS                  EXTNAME(GPCURRPD)
     D***                                  PREFIX(A6:2)
     D DsGPCURR      E DS                  EXTNAME(SDZCURRPD)
     D                                     PREFIX(A6:2)
     D  Z6NBDP       E                     EXTFLD(Z6NBDP)
     D  Z6SPRT       E                     EXTFLD(ZZSPRT)
     D  Z6LCD        E                     EXTFLD(Z6LCD)
     D  Z6TXND       E                     EXTFLD(Z6TXND)
     D  Z6PRRT       E                     EXTFLD(Z6PRRT)
     D  Z6SRC1       E                     EXTFLD(Z6SRC1)
     D  Z6SRC2       E                     EXTFLD(Z6SRC2)
     D  Z6SSNB       E                     EXTFLD(Z6SSNB)
     D  Z6ERLC       E                     EXTFLD(Z6ERLC)
     D  Z6SPDY       E                     EXTFLD(Z6SPDY)
     D  Z6HSRT       E                     EXTFLD(Z6HSRT)
     D  Z6LSPR       E                     EXTFLD(Z6LSPR)
     D  Z6FXSD       E                     EXTFLD(Z6FXSD)
     D  Z6MMSD       E                     EXTFLD(Z6MMSD)
     D  Z6NQDP       E                     EXTFLD(Z6NQDP)
     D  Z6SCEX       E                     EXTFLD(Z6SCEX)
     D  Z6HBRT       E                     EXTFLD(Z6HBRT)
     D  Z6ENC1       E                     EXTFLD(Z6ENC1)
     D  Z6ENC2       E                     EXTFLD(Z6ENC2)
     D  Z6CNMC       E                     EXTFLD(Z6CNMC)
     D  Z6DPBF       E                     EXTFLD(Z6DPBF)
     D  Z6BYSR       E                     EXTFLD(Z6BYSR)
     D  Z6SLSR       E                     EXTFLD(Z6SLSR)
     D  Z6RMCM       E                     EXTFLD(Z6RMCM)
     D  Z6RKSQ       E                     EXTFLD(Z6RKSQ)
     D  Z6TKCC       E                     EXTFLD(Z6TKCC)
     D  Z6CQCD       E                     EXTFLD(Z6CQCD)
     D  Z6SMLD       E                     EXTFLD(Z6SMLD)
     D  Z6ISON       E                     EXTFLD(Z6ISON)
     D  Z6EUER       E                     EXTFLD(Z6EUER)
     D  Z6TPSD       E                     EXTFLD(Z6TPSD)
     D  Z6TPED       E                     EXTFLD(Z6TPED)
     D  Z6INER       E                     EXTFLD(Z6INER)
     D  Z6EXWC       E                     EXTFLD(Z6EXWC)
     D  Z6POWC       E                     EXTFLD(Z6POWC)
     D  Z6CYD1       E                     EXTFLD(Z6CYD1)
     D  Z6CYD2       E                     EXTFLD(Z6CYD2)
     D  Z6CYD3       E                     EXTFLD(Z6CYD3)
     D  Z6RENO       E                     EXTFLD(Z6RENO)
     D  Z6SWDP       E                     EXTFLD(Z6SWDP)
     D  Z6SWDT       E                     EXTFLD(Z6SWDT)
     D  Z6EFDT       E                     EXTFLD(Z6EFDT)
     D  Z6DFTS       E                     EXTFLD(Z6DFTS)
     D  Z6SRTM       E                     EXTFLD(ZZSRTM)
     D  Z6SETD       E                     EXTFLD(Z6SETD)
     D  Z6IRDP       E                     EXTFLD(Z6IRDP)
     D  Z6FXDY       E                     EXTFLD(Z6FXDY)
     D  Z6EACC       E                     EXTFLD(Z6EACC)
      ** DS for currencies
 
     D DsGPNARR      E DS                  EXTNAME(GPNARRPD)
      ** DS for narratives
 
     D*DsGPACOF      E DS                  EXTNAME(GPACOFPD)
      ** DS for account officers
     D DsGPACOF      E DS                  EXTNAME(SDZACOFPD)
      ** DS for account officers
 
     D DsGPCTRY      E DS                  EXTNAME(GPCTRYPD)
      ** DS for countries
 
     D DsGPLOCN      E DS                  EXTNAME(GPLOCNPD)
      ** DS for locations
 
     D DsGPREGN      E DS                  EXTNAME(GPREGNPD)
      ** DS for regions
 
     D*DsGPBRCH      E DS                  EXTNAME(GPBRCHPD)
      ** DS for branches
     D DsGPBRCH      E DS                  EXTNAME(SDZBRCHPD)
      ** DS for branches
 
     D DsGPRECG      E DS                  EXTNAME(GPRECGPD)
     D                                     PREFIX(RE)
      ** DS for RE customer groups
 
     D DsGPLENO      E DS                  EXTNAME(GPLENOPD)
      ** DS for LE number ranges
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank ICD details
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D WFrmLib         S             10A
     D WFrmFil         S             10A
     D WToLib          S             10A
     D WToFil          S             10A
     D WCmdTxt         S            200A
     D WCmdLen         S             15P 5 INZ(200)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     ISDCURRD0
     I              A6SPRT                      A6SPRT_Z
 
     IUTCURRD0
     I              A6SPRT                      A6SPRT_Z
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   DOW       *INKC = *OFF
 
 
      ** Default Zone screen
      ** --------------------------------------------------------------
 
     C                   IF        WScr = 1
     C                   EXSR      SRScrDftZne
     C                   ENDIF
 
      ** Cascade-to-zone screen
      ** --------------------------------------------------------------
     C                   IF        WScr = 2
     C                   EXSR      SRScrCasZne
     C                   ENDIF
 
      ** Confirmation screen
      ** --------------------------------------------------------------
     C                   IF        WScr = 3
     C                   EXSR      SRScrConf
     C                   ENDIF
 
      ** Process action/s
      ** --------------------------------------------------------------
     C                   IF        WScr = 4
 
      ** Upload default zone data to central
     C                   EXSR      SRUpdGlo
 
      ** Cascade to all zones except for the default zone
     C     *LOVAL        SETLL     GPZONEL1
     C                   READ      GPZONEL1                               51
     C                   DOW       *IN51 = *OFF
 
     C                   IF        ZOMSYS <> WQDftZnePfx
 
      ** Determine if zone was selected to be cascaded with central data
     C                   MOVE      *ON           *IN47
     C                   READC     SD000081S0                             52
     C                   DOW       *IN52 = *OFF
     C                   UPDATE    SD000081S0
     C                   IF        S0MSYS=ZOMSYS AND S0ACTN='1'
     C                   LEAVE
     C                   ENDIF
     C                   READC     SD000081S0                             52
     C                   ENDDO
 
     C                   IF        *IN52=*OFF
     C                   EXSR      SRCscZne
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      GPZONEL1                               51
 
     C                   ENDDO
 
      ** Set screen to initial screen
     C                   Z-ADD     1             WScr
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrDftZne - process the Default-Zone screen.               *
      *                                                               *
      *  Called by: main routine                                      *
      *                                                               *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SRScrDftZne   BEGSR
 
      ** --------------------------------------------------------------
      ** Initialization
      ** --------------------------------------------------------------
 
      ** Reset default zone name and zone system prefix
     C                   MOVE      *BLANKS       WQDftZneNme
     C                   MOVE      *BLANKS       WQDftZnePfx
      ** Subtitle toggle
     C                   MOVE      *OFF          *IN49
      ** Show 1=Select
     C                   MOVE      *ON           *IN40
      ** Hide <F12>
     C                   MOVE      *OFF          *IN42
      ** Set on the SFLNXTCHG indicator so that all the records can be
      ** readily read
     C                   MOVE      *ON           *IN47
      ** Hide the Default Zone column of the subfile
     C                   MOVE      *OFF          *IN41
      ** Clear subfile records and do not show subfile records
     C                   MOVE      *ON           *IN46
     C                   MOVE      *OFF          *IN45
     C                   MOVE      *OFF          *IN48
     C                   WRITE     SD000081C0
     C                   MOVE      *OFF          *IN46
     C                   Z-ADD     0             S0SFRRN
 
      ** --------------------------------------------------------------
      ** Upload zones from file to subfile
      ** --------------------------------------------------------------
 
     C     *LOVAL        SETLL     GPZONEL1
     C                   READ      GPZONEL1                               50
 
     C                   DOW       *IN50=*OFF
 
     C                   MOVE      ZOZONE        S0ZONE
     C                   MOVE      ZOMSYS        S0MSYS
     C                   MOVE      *BLANK        S0ACTN
     C                   MOVE      ZODESC        S0DESC
     C                   MOVE      *BLANK        S0DFTZ
     C                   ADD       1             S0SFRRN
     C                   WRITE     SD000081S0
     C                   READ      GPZONEL1                               50
 
     C                   ENDDO
 
      ** --------------------------------------------------------------
      ** Process user' screen action
      ** --------------------------------------------------------------
 
      ** Reposition subfile record counter to the top
     C                   Z-ADD     1             S0SFRRN
 
     C                   DOW       *INKC=*OFF
 
      ** Write screen and read screen input
      **    show subfile control
     C                   MOVE      *ON           *IN48
      **    if subfile is not empty, then show it
     C                   IF        S0SFRRN > 0
     C                   MOVE      *ON           *IN45
     C                   ENDIF
     C                   WRITE     SD000081C0
     C                   WRITE     #MSGCTL
     C                   EXFMT     SD000081F9
 
      ** Call program to clear program queue
     C                   CALL      'ZA0250'
      ** Reset screen-error indicators
     C                   MOVE      *OFF          *IN22
 
      ** Process screen input
     C                   SELECT
 
      ** <F3> - leave the loop
      ** --------------------------------------------------------------
     C                   WHEN      *INKC=*ON
 
     C                   LEAVE
 
      ** <F5> - refresh action fields and loop again
      ** --------------------------------------------------------------
     C                   WHEN      *INKE=*ON
 
     C                   READC     SD000081S0                             50
     C                   DOW       *IN50=*OFF
     C                   MOVE      *BLANK        S0ACTN
     C                   UPDATE    SD000081S0
     C                   READC     SD000081S0                             50
     C                   ENDDO
     C                   ITER
 
      ** <ENTER> - process action fields
      ** --------------------------------------------------------------
     C                   OTHER
 
      ** Validate the action code of each changed subfile record
     C                   Z-ADD     0             WCtr              3 0
     C                   MOVE      'N'           WErr              1
     C                   READC     SD000081S0                             50
 
     C                   DOW       *IN50=*OFF
 
      ** --- If action field is blank, then ignore record
     C                   IF        S0ACTN=*BLANK
     C                   MOVE      *OFF          *IN22
     C                   MOVE      *BLANK        S0DFTZ
 
      ** --- action field is not blank
     C                   ELSE
      ** ---+--- If the action is 1, then increment counter.
      **         Otherwise, error.
     C                   IF        S0ACTN='1'
     C                   ADD       1             WCtr
      ** ---+---+--- If user selected more than 1, then error
     C                   IF        WCtr>1
     C                   MOVE      'Y'           WErr
     C                   MOVE      *ON           *IN22
     C                   MOVE      'UT00005   '  WMsgID
     C                   EXSR      SRSndMsg
      ** ---+---+--- Selected a default
     C                   ELSE
     C                   MOVE      'Y'           S0DFTZ
     C                   MOVE      S0ZONE        WQDftZneNme
     C                   MOVE      S0MSYS        WQDftZnePfx
     C                   ENDIF
      ** ---+---
     C                   ELSE
     C                   MOVE      'Y'           WErr
     C                   MOVE      *ON           *IN22
     C                   MOVE      'Y2MAA04   '  WMsgID
     C                   EXSR      SRSndMsg
     C                   MOVE      *BLANK        S0DFTZ
     C                   ENDIF
     C                   ENDIF
 
     C                   UPDATE    SD000081S0
     C                   READC     SD000081S0                             50
 
     C                   ENDDO
 
      ** If an invalid action field is input, then loop
     C                   IF        WErr='Y'
     C                   ITER
     C                   ENDIF
 
      ** If no selection made, then loop
     C                   IF        WCtr=0
     C                   ITER
     C                   ENDIF
 
      ** At this point, a default zone has been selected
     C                   ADD       1             WScr
     C                   LEAVE
 
     C                   ENDSL
 
     C                   ENDDO
 
      ** --------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrCasZne - process the Cascade-to-Zone screen.            *
      *                                                               *
      *  Called by: main routine                                      *
      *                                                               *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SRScrCasZne   BEGSR
 
      ** --------------------------------------------------------------
      ** Initialization
      ** --------------------------------------------------------------
 
      ** Subtitle toggle
     C                   MOVE      *ON           *IN49
      ** Show 1=Select
     C                   MOVE      *ON           *IN40
      ** Show <F12>
     C                   MOVE      *ON           *IN42
      ** Set on the SFLNXTCHG indicator so that all the records can be
      ** readily read
     C                   MOVE      *ON           *IN47
      ** Show the Default Zone column of the subfile
     C                   MOVE      *ON           *IN41
     C                   READC     SD000081S0                             50
     C                   DOW       *IN50=*OFF
      ** Tag all the zones for selection
     C                   MOVE      '1'           S0ACTN
     C                   UPDATE    SD000081S0
     C                   READC     SD000081S0                             50
     C                   ENDDO
 
      ** --------------------------------------------------------------
      ** Process user' screen action
      ** --------------------------------------------------------------
 
     C                   DOW       *INKC=*OFF
 
      ** Write screen and read screen input
      **    show subfile and subfile control
     C                   MOVE      *ON           *IN45
     C                   MOVE      *ON           *IN48
     C                   WRITE     SD000081C0
     C                   WRITE     #MSGCTL
     C                   EXFMT     SD000081F9
 
      ** Call program to clear program queue
     C                   CALL      'ZA0250'
      ** Reset screen-error indicators
     C                   MOVE      *OFF          *IN22
 
      ** Process screen input
     C                   SELECT
 
      ** <F3> - leave the loop
     C                   WHEN      *INKC=*ON
 
     C                   LEAVE
 
      ** <F5> - refresh action fields and loop again
     C                   WHEN      *INKE=*ON
 
     C                   READC     SD000081S0                             50
     C                   DOW       *IN50=*OFF
     C                   MOVE      *BLANK        S0ACTN
     C                   UPDATE    SD000081S0
     C                   READC     SD000081S0                             50
     C                   ENDDO
     C                   ITER
 
      ** <F12> - return to previous screen
     C                   WHEN      *INKL=*ON
 
     C                   SUB       1             WScr
     C                   LEAVE
 
      ** <ENTER> - process action fields
     C                   OTHER
 
     C                   Z-ADD     0             WCtr
     C                   MOVE      'N'           WErr              1
     C                   READC     SD000081S0                             50
     C                   DOW       *IN50=*OFF
      **                 If action field is blank, then ignore
     C                   IF        S0ACTN=' '
     C                   MOVE      *OFF          *IN22
     C                   ELSE
      **                 If the action field is not 1, then error
     C                   IF        S0ACTN<>'1'
     C                   MOVE      'Y'           WErr
     C                   MOVE      *ON           *IN22
     C                   MOVE      'Y2MAA04   '  WMsgID
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   ADD       1             WCtr
     C                   ENDIF
     C                   ENDIF
     C                   UPDATE    SD000081S0
     C                   READC     SD000081S0                             50
     C                   ENDDO
      **       If an invalid action field is input, then loop
     C                   IF        WErr='Y'
     C                   ITER
     C                   ENDIF
      **       If no selection, then loop
     C                   IF        WCtr=0
     C                   ITER
     C                   ENDIF
      **       At this point, all valid zones have been selected
     C                   ADD       1             WScr
     C                   LEAVE
 
     C                   ENDSL
 
     C                   ENDDO
 
      ** --------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrConf - process confirmation screen.                     *
      *                                                               *
      *  Called by: main routine                                      *
      *                                                               *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SRScrConf     BEGSR
 
      ** --------------------------------------------------------------
      ** Initialization
      ** --------------------------------------------------------------
 
      ** Reset action code
     C                   MOVE      *BLANK        S1ACTN
      ** Show 1=Select
     C                   MOVE      *OFF          *IN40
      ** Show <F12>
     C                   MOVE      *ON           *IN42
      ** Clear subfile records and do not show subfile records
     C                   MOVE      *ON           *IN46
     C                   MOVE      *OFF          *IN45
     C                   MOVE      *OFF          *IN48
     C                   WRITE     SD000081C1
     C                   MOVE      *OFF          *IN46
     C                   Z-ADD     0             S1SFRRN
 
      ** --------------------------------------------------------------
      ** Upload procedure steps to subfile
      ** --------------------------------------------------------------
 
     C                   CALL      'SDRTVTXT'
     C                   PARM      'UT00003'     WMsgID           10
     C                   PARM      'UTMSGF'      WMsgF            10
     C                   PARM      *BLANKS       WMsgTxt          80
     C                   ADD       1             S1SFRRN
     C                   MOVEL(P)  WMsgTxt       S1NARR
     C                   WRITE     SD000081S1
 
     C                   CALL      'SDRTVTXT'
     C                   PARM      'UT00004'     WMsgID
     C                   PARM      'UTMSGF'      WMsgF
     C                   PARM      *BLANKS       WMsgTxt
     C                   ADD       1             S1SFRRN
     C                   MOVEL(P)  WMsgTxt       S1NARR
     C                   WRITE     SD000081S1
 
      ** --------------------------------------------------------------
      ** Process user' screen action
      ** --------------------------------------------------------------
 
     C                   DOW       *INKC=*OFF
 
      ** If subfile is not empty, then show it
     C                   IF        S1SFRRN > 0
     C                   MOVE      *ON           *IN45
     C                   ENDIF
      ** Write screen and read screen input
     C                   MOVE      *ON           *IN48
     C                   WRITE     SD000081C1
     C                   WRITE     #MSGCTL
     C                   WRITE     SD000081F9
     C                   READ      SD000081C1
 
      ** Call program to clear program queue
     C                   CALL      'ZA0250'
      ** Reset screen-error indicators
     C                   MOVE      *OFF          *IN21
 
      ** Process screen input
     C                   SELECT
 
      ** <F3> - leave the loop
     C                   WHEN      *INKC=*ON
     C                   LEAVE
 
      ** <F5> - refresh action fields and loop again
     C                   WHEN      *INKE=*ON
     C                   MOVE      *BLANK        S1ACTN
     C                   ITER
 
      ** <F12> - return to previous screen
     C                   WHEN      *INKL=*ON
     C                   SUB       1             WScr
     C                   LEAVE
 
      ** <ENTER> - validate action code
     C                   OTHER
      **       If the action field is not Y, then error
     C                   IF        S1ACTN<>'Y' AND S1ACTN<> 'N'
     C                             AND S1ACTN<> *BLANK
     C                   MOVE      *ON           *IN21
     C                   MOVE      'Y2MAA04   '  WMsgID
     C                   EXSR      SRSndMsg
     C                   ITER
     C                   ENDIF
      **       At this point, it has been confirmed to process actions
     C                   IF        S1ACTN='Y'
     C                   ADD       1             WScr
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdGlo - replace the central files with data from the      *
      *             selected default zone.                            *
      *                                                               *
      *  Called by: main routine                                      *
      *                                                               *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SRUpdGlo      BEGSR
 
      ** Default values
     C                   EVAL      WFrmLib=WQDftZnePfx+'DMLIB'
 
      ** Upload Account Codes
     C                   IF        CSD032 = 'Y'
     C                   EXSR      SRCpyF_ACOD
     C                   ENDIF
 
      ** Upload DL Account Keys
     C                   IF        CSD033 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'ACKEYAL   '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPAKEYPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt          10
     C                   PARM      '*NO '        WCrtFil          10
     C                   PARM      '*MAP*DROP '  WFmtOpt          10
     C                   ENDIF
 
      ** Upload FF Account Keys
     C                   IF        CSD034 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'FACKYD    '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPFAKYPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil          10
     C                   PARM      '*MAP*DROP '  WFmtOpt          10
     C                   ENDIF
 
      ** Upload SE Account Keys
     C                   IF        CSD036 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SEACKD    '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPSAKYPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt          10
     C                   PARM      '*NO '        WCrtFil          10
     C                   PARM      '*MAP*DROP '  WFmtOpt          10
     C                   ENDIF
 
      ** Upload Customers
     C                   IF        CSD037 = 'Y'
     C                   EXSR      SRCpyF_CUST
     C                   ENDIF
 
      ** Upload Sub-types
     C                   IF        CSD038 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDDLSTPD  '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPDLSTPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Upload Deal Type/Sub-types
     C                   IF        CSD039 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'FDDTSTPD  '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPDTSTPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Upload Facility Types
     C                   IF        CSD040 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDFACTPD  '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPFACTPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Upload Holidays
     C                   IF        CSD041 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDHOLPD   '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPHOLIPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Upload Loan type/sub-types
     C                   IF        CSD042 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDLOANPD  '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPLOANPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Upload Currencies
     C                   IF        CSD043 = 'Y'
     C                   EXSR      SRCpyF_CURR
     C                   ENDIF
 
      ** Upload Narratives
     C                   IF        CSD044 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDNARRPD  '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPNARRPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Upload Account Officers
     C                   IF        CSD045 = 'Y'
      ** --- clear cross-reference file
     C                   EVAL      WCmdTxt=%SUBST(TbCmd(1):1:12)
     C                                   + 'GPACOFXPD)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    WCmdTxt
     C                   PARM                    WCmdLen
      ** -- replace central file with data from the default zone
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDACOFPD  '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPACOFPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
 
     C                   ENDIF
 
      ** Upload Country Codes
     C                   IF        CSD046 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDCTRYPD  '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPCTRYPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Upload Locations
     C                   IF        CSD047 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDLOCNPD  '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPLOCNPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Upload Regions
     C                   IF        CSD048 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDREGNPD  '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPREGNPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Upload Branches
     C                   IF        CSD049 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDBRCHPD  '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPBRCHPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Upload Retail Customer Groups
     C                   IF        CSD050 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'TABLEV4   '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPRECGPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Upload Loan Number Ranges
     C                   IF        CSD051 = 'Y'
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDLENOPD  '  WFrmFil
     C                   PARM      '*LIBL     '  WToLib
     C                   PARM      'GPLENOPD  '  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*NO '        WCrtFil
     C                   PARM      '*MAP*DROP '  WFmtOpt
     C                   ENDIF
 
      ** Call program to clear program queue.
      ** The clearing message is sent to the program queue.
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCpyF_ACOD - copy Account Codes replacing the target file.  *
      *                                                               *
      *  Called by: SRUpdGlo                                          *
      *                                                               *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SRCpyF_ACOD   BEGSR
 
      ** Clear cross-reference file
     C                   EVAL      WCmdTxt=%SUBST(TbCmd(1):1:12)
     C                                   + 'GPACODXPD)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    WCmdTxt
     C                   PARM                    WCmdLen
 
      ** Clear target file
     C                   EVAL      WCmdTxt=%SUBST(TbCmd(1):1:12)
     C                                   + 'GPACODPD)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    WCmdTxt
     C                   PARM                    WCmdLen
 
      ** Copy file from the default zone to a temporary file
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDACODPD  '  WFrmFil
     C                   PARM      'QTEMP     '  WToLib
     C                   PARM      'SD000081AC'  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*YES'        WCrtFil
     C                   PARM      *BLANKS       WFmtOpt
 
      ** Read record from default zone and copy to central file
 
     C                   OPEN      GPACODPD
     C                   OPEN      SD000081AC
     C                   READ      SD000081AC                             50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      A5GACD = A5ACCD
     C                   EVAL      A5DESC = A5ACCN
     C                   EVAL      A5IUSR = A5AUSR
     C                   EVAL      A5CHTP = 'I'
     C                   EVAL      A5LCD  = ZORDNB
     C                   EVAL      A5AACC = 'N'
     C                   EVAL      A5GPDT = 'Y'
     C                   WRITE     GPACODD0
     C                   READ      SD000081AC                             50
 
     C                   ENDDO
 
     C                   CLOSE     GPACODPD
     C                   CLOSE     SD000081AC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCpyF_CUST - copy Customers replacing the target file.      *
      *                                                               *
      *  Called by: SRUpdGlo                                          *
      *                                                               *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SRCpyF_CUST   BEGSR
 
      ** Clear cross-reference files
     C                   EVAL      WCmdTxt=%SUBST(TbCmd(1):1:12)
     C                                   + 'GPCUSTXPD)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    WCmdTxt
     C                   PARM                    WCmdLen
 
      ** Clear target file
     C                   EVAL      WCmdTxt=%SUBST(TbCmd(1):1:12)
     C                                   + 'GPCUSTPD)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    WCmdTxt
     C                   PARM                    WCmdLen
 
      ** Copy file from the default zone to a temporary file
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDCUSTPD  '  WFrmFil
     C                   PARM      'QTEMP     '  WToLib
     C                   PARM      'SD000081CS'  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*YES'        WCrtFil
     C                   PARM      *BLANKS       WFmtOpt
 
      ** Read record from default zone and copy to central file
 
     C                   OPEN      GPCUSTPD
     C                   OPEN      SD000081CS
     C                   READ      SD000081CS                             50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVALR     BBBGCUS = BBBCUST
     C                   EVAL      BBBGACO = BBBACOC
     C                   EVAL      BBBGICD = BBBLICD
     C                   EVAL      BBBLCD =  ZORDNB
     C                   EVAL      BBBCHTP = 'I'
     C                   EVAL      BBBCUSR = BBBAUSR
     C                   EVAL      BBBIUSR = *BLANKS
     C                   EVAL      BBBXUSR = *BLANKS
     C                   EVAL      BBBAACC = 'N'
     C                   EVAL      BBBGPDT = 'Y'
     C                   WRITE     GPCUSTD0
     C                   READ      SD000081CS                             50
 
     C                   ENDDO
 
     C                   CLOSE     GPCUSTPD
     C                   CLOSE     SD000081CS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCpyF_CURR - copy Currencies replacing the target file.     *
      *                                                               *
      *  Called by: SRUpdGlo                                          *
      *                                                               *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SRCpyF_CURR   BEGSR
 
      ** Clear target file
     C                   EVAL      WCmdTxt=%SUBST(TbCmd(1):1:12)
     C                                   + 'GPCURRPD)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    WCmdTxt
     C                   PARM                    WCmdLen
 
      ** Copy file from the default zone to a temporary file
     C                   CALL      'SDCCPYF'
     C                   PARM                    WFrmLib
     C                   PARM      'SDCURRPD  '  WFrmFil
     C                   PARM      'QTEMP     '  WToLib
     C                   PARM      'SD000081CR'  WToFil
     C                   PARM      '*REPLACE  '  WMbrOpt
     C                   PARM      '*YES'        WCrtFil
     C                   PARM      *BLANKS       WFmtOpt
 
      ** Read record from default zone and copy to central file
 
     C                   OPEN      GPCURRPD
     C                   OPEN      SD000081CR
     C                   READ      SD000081CR                             50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      A6DESC = A6CYNM
     C                   EVAL      A6SPRT = A6SPRT_Z
     C                   EVAL      A6CHTP = 'I'
     C                   EVAL      A6LCD  = ZORDNB
     C                   EVAL      A6CUSR = A6AUSR
     C                   EVAL      A6IUSR = *BLANKS
     C                   EVAL      A6XUSR = *BLANKS
     C                   EVAL      A6AACC = 'N'
     C                   EVAL      A6GPDT = 'Y'
     C
     C                   WRITE     GPCURRD0
     C                   READ      SD000081CR                             50
 
     C                   ENDDO
 
     C                   CLOSE     GPCURRPD
     C                   CLOSE     SD000081CR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCscZne - cascade central data to a zone.                   *
      *                                                               *
      *  Called by: main routine                                      *
      *                                                               *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SRCscZne      BEGSR
 
      ** --------------------------------------------------------------
      ** Initialization
      ** --------------------------------------------------------------
 
     C                   EVAL      WDtqNme = 'SDACCPDTQ'
     C                   EVAL      WDtqLib = ZOMSYS + 'DPLIB'
 
      ** --------------------------------------------------------------
      ** Cascade Account Codes to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD032 = 'Y'
 
     C                   OPEN      GPACODPD
     C                   EVAL      WDtqDta = 'GPACODPD'
 
     C                   READ      GPACODPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   MOVE      A5LCD         A5LCD1
     C                   MOVE      A5SRLC        A5SRLC1
     C                   MOVE      A5SRFC        A5SRFC1
     C                   MOVE      A5RPCD        A5RPCD1
     C                   MOVE      A5ACPR        A5ACPR1
     C                   MOVE      A5MISU        A5MISU1
     C                   MOVE      A5TRDA        A5TRDA1
     C                   MOVE      A5TRCA        A5TRCA1
     C                   MOVE      A5EACC        A5EACC1
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = A5GACD
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPACOD
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme          10
     C                   PARM                    WDtqLib          10
     C                   PARM                    WDtqDta        4040
     C                   READ      GPACODPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPACODPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade DL Account Keys to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD033 = 'Y'
 
     C                   OPEN      GPAKEYPD
     C                   EVAL      WDtqDta = 'GPAKEYPD'
 
     C                   READ      GPAKEYPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = AKEY
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPAKEY
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPAKEYPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPAKEYPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade FF Account Keys to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD034 = 'Y'
 
     C                   OPEN      GPFAKYPD
     C                   EVAL      WDtqDta = 'GPFAKYPD'
 
     C                   READ      GPFAKYPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = FKFFKY
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPFAKY
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPFAKYPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPFAKYPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade SE Account Keys to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD036 = 'Y'
 
     C                   OPEN      GPSAKYPD
     C                   EVAL      WDtqDta = 'GPSAKYPD'
 
     C                   READ      GPSAKYPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = SKACKE
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPSAKY
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPSAKYPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPSAKYPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade Customers to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD037 = 'Y'
 
     C                   OPEN      GPCUSTPD
     C                   EVAL      WDtqDta = 'GPCUSTPD'
 
     C                   READ      GPCUSTPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   MOVE      BBBCHID       C_CUCHID
     C                   MOVE      BBBCHSC       C_CUCHSC
     C                   MOVE      BBBCABA       C_CUCABA
     C                   MOVE      BBBABA2       C_CUABA2
     C                   MOVE      BBBFWCD       C_CUFWCD
     C                   MOVE      BBBDOIC       C_CUDOIC
     C                   MOVE      BBBSSDT       C_CUSSDT
     C                   MOVE      BBBDTDL       C_CUDTDL
     C                   MOVE      BBBLCD        C_CULCD
     C                   MOVE      BBBDEDT       C_CUDEDT
     C                   MOVE      BBBMGTP       C_CUMGTP
     C                   MOVE      BBBEACC       C_CUEACC
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = BBBCUST
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPCUST
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPCUSTPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPCUSTPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade Sub-types to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD038 = 'Y'
 
     C                   OPEN      GPDLSTPD
     C                   EVAL      WDtqDta = 'GPDLSTPD'
 
     C                   READ      GPDLSTPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = ASDSTC
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPDLST
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPDLSTPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPDLSTPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade DL type/sub-types to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD039 = 'Y'
 
     C                   OPEN      GPDTSTPD
     C                   EVAL      WDtqDta = 'GPDTSTPD'
 
     C                   READ      GPDTSTPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = DTPE11 + DLST11
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPDTST
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPDTSTPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPDTSTPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade Facility Types to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD040 = 'Y'
 
     C                   OPEN      GPFACTPD
     C                   EVAL      WDtqDta = 'GPFACTPD'
 
     C                   READ      GPFACTPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = AMFCTY
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPFACT
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPFACTPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPFACTPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade Holidays to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD041 = 'Y'
 
     C                   OPEN      GPHOLIPD
     C                   EVAL      WDtqDta = 'GPHOLIPD'
 
     C                   READ      GPHOLIPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = DGCYCD + DGLCCD
     C                                                     + DGYRNB
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPHOLI
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPHOLIPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPHOLIPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade LE Type/Sub-types to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD042 = 'Y'
 
     C                   OPEN      GPLOANPD
     C                   EVAL      WDtqDta = 'GPLOANPD'
 
     C                   READ      GPLOANPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = LEAYLNTY + LEAYLNST
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPLOAN
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPLOANPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPLOANPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade Currencies to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD043 = 'Y'
 
     C                   OPEN      GPCURRPD
     C                   EVAL      WDtqDta = 'GPCURRPD'
 
     C                   READ      GPCURRPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   MOVE      A6NBDP        Z6NBDP
     C                   MOVE      A6SPRT        Z6SPRT
     C                   MOVE      A6LCD         Z6LCD
     C                   MOVE      A6TXND        Z6TXND
     C                   MOVE      A6PRRT        Z6PRRT
     C                   MOVE      A6SRC1        Z6SRC1
     C                   MOVE      A6SRC2        Z6SRC2
     C                   MOVE      A6SSNB        Z6SSNB
     C                   MOVE      A6ERLC        Z6ERLC
     C                   MOVE      A6SPDY        Z6SPDY
     C                   MOVE      A6HSRT        Z6HSRT
     C                   MOVE      A6LSPR        Z6LSPR
     C                   MOVE      A6FXSD        Z6FXSD
     C                   MOVE      A6MMSD        Z6MMSD
     C                   MOVE      A6NQDP        Z6NQDP
     C                   MOVE      A6SCEX        Z6SCEX
     C                   MOVE      A6HBRT        Z6HBRT
     C                   MOVE      A6ENC1        Z6ENC1
     C                   MOVE      A6ENC2        Z6ENC2
     C                   MOVE      A6CNMC        Z6CNMC
     C                   MOVE      A6DPBF        Z6DPBF
     C                   MOVE      A6BYSR        Z6BYSR
     C                   MOVE      A6SLSR        Z6SLSR
     C                   MOVE      A6RMCM        Z6RMCM
     C                   MOVE      A6RKSQ        Z6RKSQ
     C                   MOVE      A6TKCC        Z6TKCC
     C                   MOVE      A6CQCD        Z6CQCD
     C                   MOVE      A6SMLD        Z6SMLD
     C                   MOVE      A6ISON        Z6ISON
     C                   MOVE      A6EUER        Z6EUER
     C                   MOVE      A6TPSD        Z6TPSD
     C                   MOVE      A6TPED        Z6TPED
     C                   MOVE      A6INER        Z6INER
     C                   MOVE      A6EXWC        Z6EXWC
     C                   MOVE      A6POWC        Z6POWC
     C                   MOVE      A6CYD1        Z6CYD1
     C                   MOVE      A6CYD2        Z6CYD2
     C                   MOVE      A6CYD3        Z6CYD3
     C                   MOVE      A6RENO        Z6RENO
     C                   MOVE      A6SWDP        Z6SWDP
     C                   MOVE      A6SWDT        Z6SWDT
     C                   MOVE      A6EFDT        Z6EFDT
     C                   MOVE      A6DFTS        Z6DFTS
     C                   MOVE      A6SRTM        Z6SRTM
     C                   MOVE      A6SETD        Z6SETD
     C                   MOVE      A6IRDP        Z6IRDP
     C                   MOVE      A6FXDY        Z6FXDY
     C                   MOVE      A6EACC        Z6EACC
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = A6CYCD
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPCURR
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPCURRPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPCURRPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade Narratives to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD044 = 'Y'
 
     C                   OPEN      GPNARRPD
     C                   EVAL      WDtqDta = 'GPNARRPD'
 
     C                   READ      GPNARRPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = ALNVCD
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPNARR
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPNARRPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPNARRPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade Account Officers to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD045 = 'Y'
 
     C                   OPEN      GPACOFPD
     C                   EVAL      WDtqDta = 'GPACOFPD'
 
     C                   READ      GPACOFPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   MOVE      AZLCD         ZZLCD
     C                   MOVE      AZACOT        ZZACOT
     C                   MOVE      AZEACC        ZZEACC
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = AZACOC
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPACOF
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPACOFPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPACOFPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade Countries to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD046 = 'Y'
 
     C                   OPEN      GPCTRYPD
     C                   EVAL      WDtqDta = 'GPCTRYPD'
 
     C                   READ      GPCTRYPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = A4CNCD
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPCTRY
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPCTRYPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPCTRYPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade Locations to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD047 = 'Y'
 
     C                   OPEN      GPLOCNPD
     C                   EVAL      WDtqDta = 'GPLOCNPD'
 
     C                   READ      GPLOCNPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = DVLCCD
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPLOCN
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPLOCNPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPLOCNPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade Regions to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD048 = 'Y'
 
     C                   OPEN      GPREGNPD
     C                   EVAL      WDtqDta = 'GPREGNPD'
 
     C                   READ      GPREGNPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = A3RGCD
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPREGN
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPREGNPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPREGNPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade Branches to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD049 = 'Y'
 
     C                   OPEN      GPBRCHPD
     C                   EVAL      WDtqDta = 'GPBRCHPD'
 
     C                   READ      GPBRCHPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   MOVE      A8LCD         Z8LCD
     C                   MOVE      A8STCD        Z8STCD
     C                   MOVE      A8SUOP        Z8SUOP
     C                   MOVE      A8SUCL        Z8SUCL
     C                   MOVE      A8MOOP        Z8MOOP
     C                   MOVE      A8MOCL        Z8MOCL
     C                   MOVE      A8TUOP        Z8TUOP
     C                   MOVE      A8TUCL        Z8TUCL
     C                   MOVE      A8WEOP        Z8WEOP
     C                   MOVE      A8WECL        Z8WECL
     C                   MOVE      A8THOP        Z8THOP
     C                   MOVE      A8THCL        Z8THCL
     C                   MOVE      A8FYOP        Z8FYOP
     C                   MOVE      A8FYCL        Z8FYCL
     C                   MOVE      A8SAOP        Z8SAOP
     C                   MOVE      A8SACL        Z8SACL
     C                   MOVE      A8SYCU        Z8SYCU
     C                   MOVE      A8EDAT        Z8EDAT
     C                   MOVE      A8COTI        Z8COTI
     C                   MOVE      A8TCPP        Z8TCPP
     C                   MOVE      A8TMOF        Z8TMOF
     C                   MOVE      A8STOF        Z8STOF
     C                   MOVE      A8EACC        Z8EACC
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = A8BRCD
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPBRCH
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPBRCHPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPBRCHPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade RE Customer Groups to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD050 = 'Y'
 
     C                   OPEN      GPRECGPD
     C                   EVAL      WDtqDta = 'GPRECGPD'
 
     C                   READ      GPRECGPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = REZZ010
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPRECG
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPRECGPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPRECGPD
 
     C                   ENDIF
 
      ** --------------------------------------------------------------
      ** Cascade LE Number Ranges to a zone
      ** --------------------------------------------------------------
 
     C                   IF        CSD051 = 'Y'
 
     C                   OPEN      GPLENOPD
     C                   EVAL      WDtqDta = 'GPLENOPD'
 
     C                   READ      GPLENOPD                               50
 
     C                   DOW       *IN50 = *OFF
 
     C                   EVAL      %SUBST(WDtqDta:11:30) = F9RGNB
     C                   EVAL      %SUBST(WDtqDta:41:4000) = DsGPLENO
     C                   CALL      'SDCSNDDTQ'
     C                   PARM                    WDtqNme
     C                   PARM                    WDtqLib
     C                   PARM                    WDtqDta
     C                   READ      GPLENOPD                               50
 
     C                   ENDDO
 
     C                   CLOSE     GPLENOPD
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg  - sends message to the program queue.              *
      *                                                               *
      *  Called by: error-validation routines                         *
      *                                                               *
      *  Calls: ZA0350                                                *
      *                                                               *
      *****************************************************************
     C     SRSndMsg      BEGSR
 
     C                   CALL      'ZA0350'
     C                   PARM                    WMsgF            10
     C                   PARM                    WMsgID           10
     C                   PARM                    WMsgDta          45
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Default zone name and zone system prefix
     C     *LIKE         DEFINE    ZOZONE        WQDftZneNme
     C     *LIKE         DEFINE    ZOMSYS        WQDftZnePfx
 
     C                   MOVEL     PSUser        SUSER
     C                   MOVEL     PSJobName     SWSID
     C                   MOVEL     PSProcPgm     ##PGM
     C                   MOVEL     'UTMSGF'      WMsgF
 
      ** Data base error in file (file)
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
 
      ** Bank ICD
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        WRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      BJMRDT        SRUNA
 
      ** Enhancement flag for the Account Codes
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*VERIFY'     WOPTN             7
     C                   PARM      'CSD032'      WSARD             6
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD032            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD032
     C                   ENDSL
 
      ** Enhancement flag for the Dealing Account Keys
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD033'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD033            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD033
     C                   ENDSL
 
      ** Enhancement flag for the Futures and Options Account Keys
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD034'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD034            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD034
     C                   ENDSL
 
      ** Enhancement flag for the Securities Account Keys
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD036'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD036            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD036
     C                   ENDSL
 
      ** Enhancement flag for the Customers
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD037'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD037            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD037
     C                   ENDSL
 
      ** Enhancement flag for the Deal Sub-Types
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD038'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD038            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD038
     C                   ENDSL
 
      ** Enhancement flag for the Deal Type/Sub-types
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD039'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD039            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 8
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD039
     C                   ENDSL
 
      ** Enhancement flag for the Facility Types
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD040'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD040            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 9
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD040
     C                   ENDSL
 
      ** Enhancement flag for the Holidays
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD041'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD041            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 10
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD041
     C                   ENDSL
 
      ** Enhancement flag for the Loan types/sub-types
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD042'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD042            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 11
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD042
     C                   ENDSL
 
      ** Enhancement flag for the Currencies
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD043'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD043            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 12
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD043
     C                   ENDSL
 
      ** Enhancement flag for the Narratives
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD044'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD044            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 13
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD044
     C                   ENDSL
 
      ** Enhancement flag for the Account Officers
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD045'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD045            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 14
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD045
     C                   ENDSL
 
      ** Enhancement flag for the Countries
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD046'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD046            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 15
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD046
     C                   ENDSL
 
      ** Enhancement flag for the Locations
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD047'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD047            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 16
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD047
     C                   ENDSL
 
      ** Enhancement flag for the Region Code
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD048'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD048            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 17
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD048
     C                   ENDSL
 
      ** Enhancement flag for the Branche Code
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD049'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD049            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 18
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD049
     C                   ENDSL
 
      ** Enhancement flag for Retail Customer groups
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD050'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD050            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 19
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD050
     C                   ENDSL
 
      ** Enhancement flag for the Loan Number ranges
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD051'      WSARD
 
     C                   SELECT
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           CSD051            1
 
     C                   WHEN      WRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 20
     C                   EVAL      DBKEY = WSARD
     C                   EXSR      *PSSR
 
     C                   OTHER
     C                   MOVE      'N'           CSD051
     C                   ENDSL
 
      ** Initialise to start with the initial screen
     C                   Z-ADD     1             WScr              1 0
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
** TbCmd - Compile-time array of commands
CLRPFM FILE(&L/&F)
