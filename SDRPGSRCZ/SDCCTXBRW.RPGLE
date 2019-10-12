     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details by Country of Tax Browse')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCCTXBRW - Customer by Country of Tax Browse                *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23573           Date 30Mar09               *
      *                 BUG23543           Date 24Mar09               *
      *                 BUG23223           Date 04Mar09               *
      *                 BUG22578A          Date 17Feb09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER034             Date 06Aug08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243769             Date 04Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 234227             Date 27Jun05               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  CGL157 - CRS Reporting (Recompile)                           *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23573 - Database error and timeout occurs when            *
      *             deleting ACUD entries                             *
      *  BUG23543 - Customer number is missing in Customer details    *
      *             by Country of Tax                                 *
      *  BUG23223 - Incorrect '@Scrn' value set during Update run     *
      *  BUG22578A - Amend screen flow for German Taxes               *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER048 - German Features - Taxes                             *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  243769 - to supplement fix 234227.                           *
      *           Browser module was changed, by the same occasion,   *
      *           to allow data to be repaired without                *
      *           applying any change to it                           *
      *  236137 - Change Control for CGL031                           *
      *  234227 - Add function for record/s deletion.                 *
      *  232543 - Fix to CGL031                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SD Customer Details by Country of Tax Display
     FSDCCTXBDF CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SDCCTXS0:WkSRRN)

      ** Midas SD CCTX by Customer
     FSDACTXL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDACTXD0:SDACTXD4)

      ** Midas SD CCTX by Country
     FSDACTXL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDACTXD0:SDACTXD5)

      ** Midas SD CCTX by Certificate Reference
     FSDACTXL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDACTXD0:SDACTXD6)

      ** Midas SD CCTX by Country/Certificate Reference
     FSDACTXL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDACTXD0:SDACTXD7)

      ** Country of Tax Codes by Ctry of Residence
     FSDCTTXL2  IF   E           K DISK    INFSR(*PSSR)

      ** Customer Details by Country of Tax - Update
     FSDACTXL0  UF A E           K DISK    COMMIT

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Standard D-specs
      ** ================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
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

      ** The following /COPY includes the MM standard declares:

     D/COPY ZACPYSRC,STDDECLARE

      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.

     D/COPY ZACPYSRC,MSGHNDDCL

      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.

     D/COPY ZACPYSRC,APICTLARR

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

     D WErrIndArr      S              1    DIM(60)

      ** New Details in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(SDCCTXPD)

      ** Current Details in Screen Format
     D CrDlScnFmt    E DS                  EXTNAME(SDCCTXPD)
     D                                     PREFIX(Cr)

      ** Error indicator file
     D OkFlags       E DS                  EXTNAME(SDECCTXPD)

      ** Data Structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Data Structure for Additional Customer Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** Data Structure for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)

      ** Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
                                                                                              232543
      ** Long Data Structure (more than 800 length)                                           232543
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     232543

      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  SFleEnd               96     96
     D  SFleClr               97     97
     D  RollUp                98     98
     D  NoSflChgRec           99     99

      ** Selection fields data structure
     D DSSelect        DS
     D  SECTTX                01     02
     D  SECERF                03     22

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Entry Parameters
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PUpSfl          S              1A
     D PRedisp         S              1A
     D PCustNo         S              6A
     D PAction         S              1A                                                      234227
     D PProtect        S              1A
     D PRepair         S              1A
     D BJMRDT          S              7A
     D BJDFIN          S              1A
     D PExit           S              1A
     D PDelete         S              1A                                                      234227
     D PCancel         S              1A
     D PCtrySel        S              2A
     D PRtcd           S              7A
     D POptn           S              7A
     D PKey            S             10A
     D PKySt           S              7A
     D PCtry           S              2A
     D PSard           S              6A

      ** Work Variables
     D WkSRRN          S              5  0
     D WRelNo          S              5  0
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
     D ZError          S              1A
     D WBuild          S              1A
     D WCtr1           S              2  0
     D WCtr2           S              2  0
     D WSelec          S              1A
     D WWrite          S              1A
     D WExpDat         S              5  0
     D CSC011          S              1A
     D CER048          S              1A                                                      CER048
     D WResDat         S              5P 0                                                    CER048
     D WApvDat         S              5P 0                                                    CER048
     D WValDat         S              5P 0                                                    CER048
     D WZdt11          S              6A                                                      CER048

      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

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

      ** Initialisation

     C                   EXSR      SRInit

      ** Check if record already exist

     C                   IF        PProtect <> 'Y'                                            232543
     C                   EXSR      SRChkRec
     C                   ENDIF                                                                232543

     C                   IF        PBdSfl = 'Y'

     C                   DOU       WBuild = 'N'

     C                   IF        PRedisp <> 'Y' OR
     C                             WBuild = 'Y'

      ** Build subfile

     C                   IF        PRepair = 'Y'
     C                   EXSR      SRBldSflR
     C                   ELSE
     C                   EXSR      SRBldSfl
     C                   ENDIF

     C                   ELSE

      ** Redisplay subfile

     C                   IF        PRepair = 'Y'
     C                   EXSR      SRRdpSflR
     C                   ELSE
     C                   EXSR      SRRdpSfl
     C                   ENDIF

     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

      ** Read Subfile Record

     C                   IF        PRdSfl = 'Y'
     C                   EXSR      SRRdSflR
     C                   ENDIF

      ** Update subfile Record

     C                   IF        PUpSfl = 'Y'
     C                   EXSR      SRUpdSflR
     C                   ENDIF

      ** Return

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl - Build Subfile                                      *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR

     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN36 = *OFF                                               236137
     C                   EVAL      *IN37 = *OFF                                               CER048
     C                   EVAL      *IN38 = *OFF                                               CER048
     C                   EVAL      *IN39 = *OFF                                               CER048
     C                   EVAL      WBuild = 'N'

     C                   EVAL      EndOfFile = False
     C                   EVAL      SFleEnd = False

      ** Initialise subfile relative record number

     C                   EVAL      WkSRRN = 0

      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.

     C                   EVAL      SFleClr = True
     C                   WRITE     SDCCTXC0
     C                   EVAL      SFleClr = False

      ** Write the select screen footer to the screen.

     C                   IF        PAction = 'D'                                              234227
     C                   WRITE     SDCCTXF2                                                   234227
     C                   ELSE                                                                 234227
     C                   WRITE     SDCCTXF0
     C                   ENDIF                                                                234227

      ** Set file pointer to start of file

     C                   SELECT

     C                   WHEN      WSelec = '1'
     C     WKey1         SETLL     SDACTXL4
     C                   WHEN      WSelec = '2'
     C     WKey2         SETLL     SDACTXL5
     C                   WHEN      WSelec = '3'
     C     WKey3         SETLL     SDACTXL6
     C                   WHEN      WSelec = '4'
     C     WKey4         SETLL     SDACTXL7

     C                   ENDSL

      ** Read a Valid Record

     C                   EXSR      SRRdRec

      ** Set on ROLLUP indicator to drive initial loop.

     C                   EVAL      RollUp = True

      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.

     C                   DOW       RollUp = True

      ** For each record read, write it to the subfile.
      ** Do this until end of file.

     C                   DOW       EndOfFile = FALSE

     C                   IF        WWrite = 'Y'

      ** Increment the subfile record no. and records written fields.

     C                   EVAL      WkSRRN = WkSRRN + 1

      ** Format Detail fields for output

     C                   EXSR      SRFmtDtl

      ** Write the record to the subfile.

     C                   Z-ADD     WkSRRN        DDSFRN
     C                   EVAL      *IN90 = *ON                                                CER048
     C                   WRITE     SDCCTXS0
     C                   EVAL      *IN90 = *OFF                                               CER048

     C                   ENDIF

      ** Read a record

     C                   EXSR      SRRdRec

      ** If EndOfFile seton SFleEnd

     C                   IF        EndOfFile = True
     C                   EVAL      SFleEnd = True
     C                   ENDIF

     C                   ENDDO

      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.

     C                   EVAL      DDSFRN = 1

     C                   IF        WkSRRN = 0
     C                   EVAL      Rollup = False
     C                   EVAL      DDCUST = PCustNO
     C                   EVAL      *IN21  = *OFF                                            BUG23573
     C                   EVAL      *IN22  = *OFF                                            BUG23573
     C                   EXFMT     SDCCTXD0
     C                   EVAL      DDCUST = *BLANKS
     C                   ELSE
     C                   EXFMT     SDCCTXC0
     C                   ENDIF

     C                   SELECT

      ** If F3, bypass further processing

     C                   WHEN      *INKC = *ON
     C                   EVAL      PExit = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
                                                                                              234227
      ** If F10, Delete all records                                                           234227
                                                                                              234227
     C                   WHEN      *INKJ = *ON                                                234227
     C                   EVAL      PDelete = '1'                                              234227
     C                   EVAL      *INLR = *ON                                                234227
     C                   RETURN                                                               234227

      ** If F5, Rebuild subfile

     C                   WHEN      *INKE = *ON
     C                   EVAL      WBuild = 'Y'
      *                                                                                    BUG22578A
      ** If F12 - Cancel                                                                   BUG22578A
      *                                                                                    BUG22578A
     C                   WHEN      *INKL= *ON                                              BUG22578A
     C                   EVAL      PCancel = '1'                                           BUG22578A
     C                   EVAL      *INLR = *ON                                             BUG22578A
     C                   RETURN                                                            BUG22578A
                                                                                              234227
      ** If no keys have been pressed and deletion is required,                               234227
      ** the subfile.                                                                         234227
                                                                                              234227
     C                   OTHER                                                                234227
     C                   IF        PAction = 'D'                                              234227
     C                   EVAL      WBuild = 'Y'                                               234227
     C                   ENDIF                                                                234227

     C                   ENDSL

     C                   EVAL      WSelec = '1'

      ** If Selection has been made

     C                   IF        DSSelect <> *BLANKS

     C                   SELECT

     C                   WHEN      SECTTX <> *BLANKS AND
     C                             SECERF = *BLANKS
     C                   EVAL      WSelec = '2'

     C                   WHEN      SECTTX = *BLANKS AND
     C                             SECERF <> *BLANKS
     C                   EVAL      WSelec = '3'

     C                   WHEN      SECTTX <> *BLANKS AND
     C                             SECERF <> *BLANKS
     C                   EVAL      WSelec = '4'

     C                   ENDSL

     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSflR - Build Subfile (Repair Mode)                       *
      *                                                               *
      *****************************************************************
     C     SRBldSflR     BEGSR

     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN36 = *OFF                                               236137
     C                   EVAL      *IN37 = *OFF                                               CER048
     C                   EVAL      *IN38 = *OFF                                               CER048
     C                   EVAL      *IN39 = *OFF                                               CER048
     C                   EVAL      WBuild = 'N'

     C                   EVAL      EndOfFile = False
     C                   EVAL      SFleEnd = False

      ** Initialise subfile relative record number

     C                   EVAL      WkSRRN = 0

      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.

     C                   EVAL      SFleClr = True
     C                   WRITE     SDCCTXC0
     C                   EVAL      SFleClr = False

      ** Write the select screen footer to the screen.

     C                   WRITE     SDCCTXF1

      ** Initialise Input Fields

     C                   EVAL      DDCTTX = *BLANKS
     C                   EVAL      DDDESC = *BLANKS
     C                   EVAL      DDETXS = *BLANKS
     C                   EVAL      DDCERF = *BLANKS
     C                   EVAL      DDCEEX = *BLANKS
     C                   EVAL      DDCSTS = *BLANKS                                           236137
     C                   EVAL      DDCRTP = *BLANKS                                           CER048
     C                   EVAL      DDCADT = *BLANKS                                           CER048
     C                   EVAL      DDCVDT = *BLANKS                                           CER048

      ** Set on ROLLUP indicator to drive initial loop.

     C                   EVAL      RollUp = True

      ** Setup records into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.

     C                   DOW       RollUp = True

      ** Increment the subfile record no. and records written fields.

     C                   EVAL      WkSRRN = WkSRRN + 1

      ** Setup Detail Record

     C                   EXSR      SRSetRec

      ** Seton error indicators and write error messages

     C                   EXSR      SRUpdSflR

      ** Write the record to the subfile.

     C                   Z-ADD     WkSRRN        DDSFRN
                                                                                              243769
      ** Missing/wrong related information may have been properly                             243769
      ** input/set meanwhile. Data may be repaired without any change.                        243769
      ** So, cause record to be read by get-next-changed operation.                           243769
     C                   EVAL      *IN90 = *ON                                                243769
     C                   WRITE     SDCCTXS0
     C                   EVAL      *IN90 = *OFF                                               243769

      ** Seton SFleEnd

     C                   EVAL      SFleEnd = True

     C                   EXFMT     SDCCTXC0

     C                   READC     SDCCTXS0                               99

     C                   SELECT

      ** If F3, bypass further processing

     C                   WHEN      *INKC = *ON
     C                   EVAL      PExit = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN

      ** If F12, Go back to repair browse

     C                   WHEN      *INKL= *ON
     C                   EVAL      PCancel = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN

      ** If entries have changed

     C                   WHEN      NoSflChgRec = False
     C                   EVAL      DDCUST = PCustNo
     C                   EVAL      PCtrySel = DDCTTX

      ** Rebuild subfile

     C                   OTHER
     C                   EVAL      WBuild = 'Y'

     C                   ENDSL

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdpSfl - Redisplay subfile                                  *
      *                                                               *
      *****************************************************************
     C     SRRdpSfl      BEGSR

     C                   EVAL      WBuild = 'N'

      ** Write the select screen footer to the screen.

     C                   WRITE     SDCCTXF0

      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.

     C                   IF        WRelNo <> 0
     C                   Z-ADD     WRelNo        DDSFRN
     C                   ELSE
     C                   Z-ADD     WkSRRN        DDSFRN
     C                   ENDIF
      *                                                                                     BUG23543
      ** Set Customer Number on Screen, if Blanks                                           BUG23543
      *                                                                                     BUG23543
     C                   IF        DDCUST = *BLANKS                                         BUG23543
     C                   EVAL      DDCUST = PCustNo                                         BUG23543
     C                   ENDIF                                                              BUG23543

      ** Seton SFleEnd

     C                   EVAL      SFleEnd = True

     C                   EXFMT     SDCCTXC0

     C                   EVAL      WRelNo = 0

     C                   SELECT

      ** If F3, bypass further processing.

     C                   WHEN      *INKC = *ON
     C                   EVAL      PExit = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN

      ** If F5, Rebuild subfile

     C                   WHEN      *INKE = *ON
     C                   EVAL      WBuild = 'Y'
     C                   WRITE     SDCCTXMC
      *                                                                                     BUG23223
      ** If F12 - Cancel                                                                    BUG23223
      *                                                                                     BUG23223
     C                   WHEN      *INKL= *ON                                               BUG23223
     C                   EVAL      PCancel = '1'                                            BUG23223
     C                   EVAL      *INLR = *ON                                              BUG23223
     C                   RETURN                                                             BUG23223

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdpSflR - Redisplay subfile (Repair Mode)                   *
      *                                                               *
      *****************************************************************
     C     SRRdpSflR     BEGSR

     C                   EVAL      WBuild = 'N'

      ** Write the select screen footer to the screen.

     C                   WRITE     SDCCTXF1

      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.

     C                   IF        WRelNo <> 0
     C                   Z-ADD     WRelNo        DDSFRN
     C                   ELSE
     C                   Z-ADD     WkSRRN        DDSFRN
     C                   ENDIF

      ** Seton SFleEnd

     C                   EVAL      SFleEnd = True

     C                   EXFMT     SDCCTXC0

     C                   EVAL      WRelNo = 0

     C                   READC     SDCCTXS0                               99

     C                   SELECT

      ** If F3, bypass further processing.

     C                   WHEN      *INKC = *ON
     C                   EVAL      PExit = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN

      ** If F12, Go back to repair browse

     C                   WHEN      *INKL= *ON
     C                   EVAL      PCancel = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN

      ** If entries have changed

     C                   WHEN      NoSflChgRec = False
     C                   EVAL      DDCUST = PCustNo
     C                   EVAL      PCtrySel = DDCTTX

      ** Redisplay subfile

     C                   OTHER
     C                   EVAL      WBuild = 'Y'

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdSflR - Read Subfile Record                                *
      *                                                               *
      *****************************************************************
     C     SRRdSflR      BEGSR

     C                   READC     SDCCTXS0                               99

     C                   DOU       NoSflChgRec = True OR
     C                             PCtrySel <> *BLANK
     C                   EVAL      DDCUST = PCustNo
     C                   EVAL      PCtrySel = DDCTTX
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdSflR - Update subfile record                             *
      *                                                               *
      *****************************************************************
     C     SRUpdSflR     BEGSR

      ** Move 'OK' flags into array for checking

     C                   MOVEA     OkFlags       WErrIndArr

      ** Set screen error indicators according to status of 'OK' flags

     C                   Z-ADD     1             WCtr1
     C                   Z-ADD     30            WCtr2

     C                   DOU       WCtr1 > 60
     C                   IF        WErrIndArr(WCtr1) = 'N'
     C                   EVAL      *IN(WCtr2) = '1'
     C                   IF        WRelNo = 0
     C                   EVAL      WRelNo = WkSRRN
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN(WCtr2) = '0'
     C                   ENDIF

     C                   EVAL      WCtr1 = WCtr1 + 1
     C                   EVAL      WCtr2 = WCtr2 + 1
     C                   ENDDO

      ** The following /COPY line includes processing for the error and
      ** warning messages.

      /COPY ZACPYSRC,MSGHNDDSP1

     C                   WRITE     SDCCTXMC

      ** Update screen subfile

     C                   IF        PUpSfl = 'Y'
     C                   EVAL      *IN90 = *ON
     C                   UPDATE    SDCCTXS0
     C                   EVAL      *IN90 = *OFF
     C                   ENDIF

     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdRec - Read a Record                                       *
      *                                                               *
      *****************************************************************
     C     SRRdRec       BEGSR

      ** Reset End of File indicator

     C                   EVAL      EndOfFile = False

      ** Read the file initially - if EndOfFile is set on then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.

     C                   DOU       EndOfFile = True OR
     C                             AXCTTX <> *BLANKS

      ** Read the file

     C                   SELECT

     C                   WHEN      WSelec = '1'
     C                   READ      SDACTXL4                               01
     C                   WHEN      WSelec = '2'
     C                   READ      SDACTXL5                               01
     C                   WHEN      WSelec = '3'
     C                   READ      SDACTXL6                               01
     C                   WHEN      WSelec = '4'
     C                   READ      SDACTXL7                               01

     C                   ENDSL

     C                   IF        SECEEX <> *BLANKS
     C                   EXSR      ZDATE1
     C                   ENDIF

     C                   IF        CER048 = 'Y' AND                                           CER048
     C                             SECADT <> *BLANKS                                          CER048
      *                                                                                       CER048
     C                   EVAL      WZdt11 = SECADT                                            CER048
     C                   EXSR      SRZDate11                                                  CER048
     C                   EVAL      WApvDat = WResDat                                          CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y' AND                                           CER048
     C                             SECVDT <> *BLANKS                                          CER048
      *                                                                                       CER048
     C                   EVAL      WZdt11 = SECVDT                                            CER048
     C                   EXSR      SRZDate11                                                  CER048
     C                   EVAL      WValDat = WResDat                                          CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PCustNo <> AXCUST OR
     C                             SEETXS <> *BLANK AND
     C                             SEETXS <> AXETXS OR
     C                             SECEEX <> *BLANKS AND
     C**********                   WExpDat <> AXCEEX                                          236137
     C                             WExpDat <> AXCEEX   OR                                     236137
     C                             SECSTS <> *BLANKS  AND                                     236137
     C**********                   SECSTS <> AXCSTS                                    236137 CER048
     C                             SECSTS <> AXCSTS OR                                        CER048
     C                             (CER048 = 'Y' AND                                          CER048
     C                             ((SECADT <> *BLANKS AND                                    CER048
     C                             WApvDat <> AXCADT) OR                                      CER048
     C                             (SECVDT <> *BLANKS AND                                     CER048
     C                             WValDat <> AXCVDT)))                                       CER048
      *                                                                                       CER048
     C                   EVAL      WWrite = 'N'
     C                   ELSE
     C                   EVAL      WWrite = 'Y'
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtDtl - Format Detail Fields for Output                    *
      *                                                               *
      *****************************************************************
     C     SRFmtDtl      BEGSR

      ** Customer Number
     C                   EVAL      DDCUST = PCustNO

      ** Country of Tax
     C                   EVAL      DDCTTX = AXCTTX

      ** Country Description

     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      AXCTTX        PCtry
     C     SDCTRY        PARM      SDCTRY        DSFDY

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      DDDESC = A4CNNM
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCtry
     C                   EVAL      DBFile = 'SDCTRYPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   ENDIF

      ** European Tax Status
     C                   EVAL      DDETXS = AXETXS

      ** Certificate Reference
     C                   EVAL      DDCERF = AXCERF

      ** Certificate Expiry Date

     C                   Z-ADD     AXCEEX        ZDAYNO
     C                   EXSR      ZDate2

     C                   IF        ZDATE <> 0
     C                   MOVE      ZDATE         DDCEEX
     C                   ELSE
     C                   MOVE      *BLANKS       DDCEEX
     C                   ENDIF

      ** Customer Tax Status                                                                  236137
                                                                                              236137
     C                   EVAL      DDCSTS = AXCSTS                                            236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      DDCRTP = AXCRTP                                            CER048
      *                                                                                       CER048
      ** Certificate Approval Date                                                            CER048
      *                                                                                       CER048
     C                   EVAL      ZDAYNO = AXCADT                                            CER048
     C                   EXSR      ZDATE2                                                     CER048
      *                                                                                       CER048
     C                   IF        ZDATE <> *ZEROS                                            CER048
     C                   MOVE      ZDATE         DDCADT                                       CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      DDCADT = *BLANKS                                           CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Certificate Value Date                                                               CER048
      *                                                                                       CER048
     C                   EVAL      ZDAYNO = AXCVDT                                            CER048
     C                   EXSR      ZDATE2                                                     CER048
      *                                                                                       CER048
     C                   IF        ZDATE <> *ZEROS                                            CER048
     C                   MOVE      ZDATE         DDCVDT                                       CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      DDCVDT = *BLANKS                                           CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetRec - Setup Input Record for Repair Mode                 *
      *                                                               *
      *****************************************************************
     C     SRSetRec      BEGSR

      ** Customer Number
     C                   EVAL      DDCUST = PCustNO

      ** Country of Tax
     C                   EVAL      DDCTTX = CrDDCTTX

      ** Country Description

     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CrDDCTTX      PCtry
     C     SDCTRY        PARM      SDCTRY        DSFDY

     C                   IF        *IN02 = *OFF
     C                   EVAL      DDDESC = A4CNNM
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCtry
     C                   EVAL      DBFile = 'SDCTRYPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   ENDIF

      ** European Tax Status
     C                   EVAL      DDETXS = CrDDETXS

      ** Certificate Reference
     C                   EVAL      DDCERF = CrDDCERF

      ** Certificate Expiry Date
     C                   EVAL      DDCEEX = CrDDCEEX
      *                                                                                       236137
      ** Customer Tax Status                                                                  236137
     C                   EVAL      DDCSTS = CrDDCSTS                                          236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
      ** Certificate Type                                                                     CER048
      *                                                                                       CER048
     C                   EVAL      DDCRTP = CrDDCRTP                                          CER048
      *                                                                                       CER048
      ** Certificate Approval Date                                                            CER048
      *                                                                                       CER048
     C                   EVAL      DDCADT = CrDDCADT                                          CER048
      *                                                                                       CER048
      ** Certificate Value Date                                                               CER048
      *                                                                                       CER048
     C                   EVAL      DDCVDT = CrDDCVDT                                          CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation of variables used                     *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR

      ** Initialise Work Variables

     C                   EVAL      PExit = '0'
     C                   EVAL      PDelete = '0'                                              234227
     C                   EVAL      PCancel = '0'
     C                   EVAL      EndOfFile = False
     C                   EVAL      SFleEnd = False
     C                   EVAL      WBuild = 'N'

      ** Protect input fields

     C                   IF        PProtect = 'Y'
     C                   EVAL      *IN20 = *ON
     C                   ELSE
     C                   EVAL      *IN20 = *OFF
     C                   ENDIF

      ** Set indicator for repair mode

     C                   IF        PRepair <> 'Y'
     C                   EVAL      *IN21 = *ON
     C                   ELSE
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF
                                                                                              234227
      ** Set indicator for delete mode                                                        234227
                                                                                              234227
     C                   IF        PAction = 'D'                                              234227
     C                   EVAL      *IN22 = '1'                                                234227
     C                   ELSE                                                                 234227
     C                   EVAL      *IN22 = '0'                                                234227
     C                   ENDIF                                                                234227

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkRec - Check if record already exist on file              *
      *                                                               *
      *****************************************************************
     C     SRChkRec      BEGSR

      ** If no records exist, write new ones before building subfile

     C                   EXSR      SRChkCust

     C**********         IF        E5JATP = 'I' AND BBPRBA <> 'Y' OR                          232543
     C**********                   E5JATP = 'Y' AND BBPRBA <> 'Y'                             232543
     C                   IF        E5JATP = 'I' OR                                            232543
     C                             E5JATP = 'Y'                                               232543

     C     BBCOLC        SETLL     SDCTTXL2
     C     BBCOLC        READE     SDCTTXL2

     C                   DOW       NOT %EOF(SDCTTXL2)
     C     KeyChk        CHAIN     SDACTXL0
     C                   IF        NOT%FOUND(SDACTXL0)
     C                   EXSR      SRWrite
     C                   ENDIF
     C     BBCOLC        READE     SDCTTXL2
     C                   ENDDO

      ** Blank out country of residence

     C                   EVAL      BBCOLC = *Blanks
     C     BBCOLC        SETLL     SDCTTXL2
     C     BBCOLC        READE     SDCTTXL2

     C                   DOW       NOT %EOF(SDCTTXL2)
     C     KeyChk        CHAIN     SDACTXL0
     C                   IF        NOT%FOUND(SDACTXL0)
     C                   EXSR      SRWrite
     C                   ENDIF
     C     BBCOLC        READE     SDCTTXL2
     C                   ENDDO
     C                   ENDIF

     C                   COMMIT                                                               232543
                                                                                              232543
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRWrite  - Write details                                     *
      *                                                              *
      ****************************************************************
     C     SRWrite       BEGSR

      ** Write record to SDACTXPD

     C                   EVAL      AXCUST = E5CUST
     C                   EVAL      AXCTTX = EWCTRT
     C                   EVAL      AXETXS = EWTXS1
     C                   EVAL      AXCERF = *BLANKS
     C                   EVAL      AXCEEX = *ZERO
     C                   EVAL      AXREPI = *BLANKS
     C                   EVAL      AXFRNT = *BLANKS
     C                   EVAL      AXREPA = *BLANKS
     C                   EVAL      AXCSTS = 'A'                                               236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      AXCRTP = *BLANKS                                           CER048
     C                   EVAL      AXCADT = *ZEROS                                            CER048
     C                   EVAL      AXCVDT = *ZEROS                                            CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C
      ** If CSC011 is installed, supply a Front Office ID for the
      ** transaction even if it originated from SIN module.

     C                   IF        CSC011 = 'Y'
     C                   IF        AXFRNT = *BLANKS
     C                   EVAL      AXFRNT = 'MD' + AXCUST + AXCTTX
     C                   ENDIF
     C                   ENDIF

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   MOVE      TimeStamp     AXTMST

     C                   WRITE     SDACTXD0

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkCust - Check if Customer is valid                       *
      *                                                               *
      *****************************************************************
     C     SRChkCust     BEGSR

     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCustNo
     C*****SDACUS        PARM      SDACUS        DSSDY                                        CER048
     C     SDACUS        PARM      SDACUS        DSLDY                                        CER048

     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDACUSPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   ENDIF

     C                   EVAL      PKey = PCustNo
     C**********         CALL      'AOCUSTR0'                                                 232543
     C                   CALL      'AOCUSTR1'                                                 232543
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey
     C                   PARM      *Blanks       PKySt
     C*****SDCUST        PARM      SDCUST        DSSDY                                        232543
     C     SDCUST        PARM      SDCUST        DSLDY                                        232543

     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDate2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDate2        BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDate1 - Convert  6A Date format to midas number              *
      *                                                               *
      *****************************************************************
     C     ZDate1        BEGSR

     C                   CALLB     'ZDATE1'
     C                   PARM                    SECEEX
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZError

     C                   IF        ZError = 'Y'
     C                   Z-ADD     99999         WExpDat
     C                   ELSE
     C                   Z-ADD     ZDAYNO        WExpDat
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CER048
      *****************************************************************                       CER048
      *                                                               *                       CER048
      * SRZDate11 - Convert  6A Date format to midas number           *                       CER048
      *                                                               *                       CER048
      * Called By - SRRdRec                                           *                       CER048
      *                                                               *                       CER048
      * Calls - None                                                  *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRZDate11     BEGSR                                                                CER048
      *                                                                                       CER048
     C                   CALLB     'ZDATE1'                                                   CER048
     C                   PARM                    WZdt11                                       CER048
     C                   PARM                    ZDAYNO                                       CER048
     C                   PARM                    BJDFIN                                       CER048
     C                   PARM                    ZError                                       CER048
      *                                                                                       CER048
     C                   IF        ZError = 'Y'                                               CER048
     C                   Z-ADD     99999         WResDat                                      CER048
     C                   ELSE                                                                 CER048
     C                   Z-ADD     ZDAYNO        WResDat                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT
      *****************************************************************

      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.

      /COPY ZACPYSRC,MSGHNDDSP2

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Input Parameters
      ** ================

      ** Return Code
     C                   PARM                    RetCodeIn

      ** Build subfile
     C                   PARM                    PBdSfl

      ** Read subfile record
     C                   PARM                    PRdSfl

      ** Update subfile record
     C                   PARM                    PUpSfl

      ** Redisplay Indicator
     C                   PARM                    PRedisp

      ** Customer Number
     C                   PARM                    PCustNo
                                                                                              234227
      ** Action code                                                                          234227
     C                   PARM                    PAction                                      234227

      ** Action Code
     C                   PARM                    PProtect

      ** Repair Mode Indicator
     C                   PARM                    PRepair

      ** Current Details in Screen Format
     C                   PARM                    CrDlScnFmt

      ** Rundate
     C                   PARM                    BJMRDT

      ** Date Format Indicator
     C                   PARM                    BJDFIN

      ** Screen Error Indicator
     C                   PARM                    OkFlags

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Output Parameters
      ** =================

      ** Command Keys
     C                   PARM                    PExit
     C                   PARM                    PDelete                                      234227
     C                   PARM                    PCancel

      ** Country Code Selected
     C                   PARM                    PCtrySel

      ** New Details in Screen Format
     C                   PARM                    NwDlScnFmt

      ** Initialise program name

     C                   EVAL      DBPGM = 'SDCCTXBRW'

      ** Move workstation ID to screen field

     C                   EVAL      DDWSID = PsJobName
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDRUNA = BJMRDT

      ** Initialise the fixed parameters for ZAMSGHNDLE.

     C                   EVAL      ModuleID     = 'SD'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'

      ** Set up the prime and secondary message files for
      ** finding message IDs.

     C                   EVAL      #MsgFile     = 'SDUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'

      ** Message subfile control

     C                   EVAL      *IN95 =  '1'
     C                   EVAL      DDPGMQ = '*'

      ** Set initial selection

     C                   EVAL      WSelec = '1'

     C     WKey1         KLIST
     C                   KFLD                    PCustNo

     C     WKey2         KLIST
     C                   KFLD                    SECTTX

     C     WKey3         KLIST
     C                   KFLD                    SECERF

     C     WKey4         KLIST
     C                   KFLD                    SECTTX
     C                   KFLD                    SECERF

     C     KeyChk        KLIST
     C                   KFLD                    PCustNo
     C                   KFLD                    EWCTRT

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
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ENDIF
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtCd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   EVAL      *IN91 = *ON                                                CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   EVAL      *IN91 = *OFF                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Database error                                                                       CER048
      *                                                                                       CER048
     C                   IF        PRtcd <> *BLANKS AND                                       CER048
     C                             PRtcd <> '*NRF'                                            CER048
      *                                                                                       CER048
     C                   IN        LDA                                                        CER048
     C                   EVAL      DBKey = 'CER048'                                           CER048
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER048
     C                   EVAL      DBase = 006                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048

      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

     C/COPY ZACPYSRC,PSSR_ILE

      ********************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
