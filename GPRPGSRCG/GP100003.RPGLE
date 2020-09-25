     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Global User Security - Action Codes')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP100003 - Global User Security - Action Codes               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055681         Date 31Jul20                 *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256978             Date 07Oct08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG4091            Date 27Aug04               *
      *                 BUG3052            Date  1Jul04               *
      *                 CGP001  *CREATE    Date 26May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  256978 - Fix, SPF: Authorize to all ends in error 065        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4091- Replace numeric check on zone with simple TESTN     *
      *           to avoid decimal data errors                        *
      *  BUG3052- Recompile                                           *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
     FGP100003DFCF   E             WORKSTN
     F                                     SFILE(GP100003F1:RRN1)
     F                                     SFILE(GP100003F4:RRN2)
     FGZSDBRCHL0IF   E           K DISK
     FGPMBRBS   IF   E           K DISK
     FGPMENUJ0  IF   E           K DISK
     FGPMACBR1  UF A E           K DISK
     FGPMTXTL3  IF   E           K DISK
     FGPWMACBRDDUF A E           K DISK
     F                                     RENAME(MACBRDDF:GPWMACBRDF)
     F                                     PREFIX(SF)

     F/EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01         HELP KEY                                         *
      *   21         INSERT                                           *
      *   22         AMEND                                            *
      *   23         ENQUIRE                                          *
      *   24         DELETE                                           *
      *   26         ENQUIRY ON A DELETED RECORD                      *
      *                                                               *
      *    BRANCH SELECTION SCREEN INDICATORS                         *
      *    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         *
      *   04         ERROR INDICATOR                                  *
      *   05         SUBFILE CLEAR                                    *
      *   06         SFLDSPCTL                                        *
      *   07         SFLDSP                                           *
      *   08         SUBFILE END                                      *
      *   09         SFLNXTCHG                                        *
      *   10         DISPLAY SCREEN                                   *
      *   11         ERROR INDICATOR                                  *
      *   12         SELECT IN ERROR - NOT 'Y' OR BLANK               *
      *   13         SELECT 'Y' NOT ALLOWED - NO ACTION CODES EXIST   *
      *   14         NO MORE 'READ CHANGED' RECORDS ON SUBFILE        *
      *                                                               *
      *    ACTION CODES DETAILS SCREEN INDICATORS                     *
      *    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                     *
      *   16         SFLDSPCTL                                        *
      *   17         SFLDSP                                           *
      *   18         SUBFILE END                                      *
      *   19         SFLNXTCHG                                        *
      *   20         DISPLAY SCREEN                                   *
      *   21         INSERT                                           *
      *   22         AMEND                                            *
      *   24         DELETE                                           *
      *   27         ERROR CODE 065 ALREADY IN ARRAY                  *
      *   28         ERROR CODE 066 ALREADY IN ARRAY                  *
      *   30         GENERAL ERROR INDICATOR                          *
      *   31         ACTION CODE SELECTION IN ERROR NOT VALID (MITEM) *
      *   32         DUPLICATION OF ACTION CODE - ERROR               *
      *   33         GPMENUJ0 - CHAIN FAILED                          *
      *   37         NO MORE 'READ CHANGED' RECORDS ON SUBFILE        *
      *   38         PREFIX OF THE MENU ITEM UNIQUE CODE IS NUMERIC   *
      *                                                               *
      *   40         GPMBRBS - CHAIN FAIL, OR RECORD NOT LIVE         *
      *   41         GPMACBR1 - CHAIN/READ FAIL, OR NO MORE RECORDS   *
      *              FOR THIS USER PROFILE AND BRANCH                 *
      *   42         GPMACBR1 - RECORD NOT LIVE (IE. RECIAC NOT 'D')  *
      *   43         GPWMACBRDD - NO RECORD FOUND INDICATOR           *
      *                                                               *
      *   45         USER'S BR. CODE ARRAY - AT LEAST ONE BR.         *
      *                                                               *
      *   50         MITEMJ0 - END OF FILE (FOR MENU GROUP)           *
      *   51         LIVE MITEMJ0 RECORD (IE. RECIIT = 'D')           *
      *   52         MODULE EXISTS IN THE SYSTEM                      *
      *   53         MENU ITEM HAS ACTION CODES                       *
      *   54         USER'S SEC. LEVEL  =/LT  MENU ITEM'S SEC. LEVEL  *
      *                                                               *
      *   64         ELEMENT OF ARRAY BLANK                           *
      *   65         VALUES IN LOKUP OPERATION ARE EQUAL              *
      *   66         ELEMENT OF ARRAY BLANK                           *
      *                                                               *
      *   70         MULTIBRANCH INDICATOR = 'Y'                      *
      *                                                               *
      *   72         DEFAULTED ACTION CODES INDICATOR                 *
      *                                                               *
      *   75         GZSDBRCHPD - CHAIN FAIL                          *
      *                                                               *
      *   80         NO RECORDS FOR USER/BRANCH ON MACBR1             *
      *                                                               *
      *****************************************************************
     F/EJECT
     D BRU             S              3    DIM(900) ASCEND
     D CRRN            S              4  0 DIM(8000)
      *
     D MSG             S             23    DIM(1) CTDATA PERRCD(1)
     D MITM            S              1    DIM(10)
     D MACB            S              1    DIM(10)
     D WRKB            S              1    DIM(10)
     D WRKC            S              1    DIM(10)
     D LDA             DS           256
      *
      ** Local data area.
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D ARRDS           DS
     D*
     D*    HOLDS DISPLAY SCREEN ERROR CODES
     D  SERCD                  1     78
     D  ARR                    1     76
     D                                     DIM(19)
     D                 DS
     D  KEYFLDS                1     83
     D  SINDX                  1     10
     D  SSNAM                 11     30
     D  SINAR                 31     63
     D  SPACD                 64     73
     D  SACAD                 74     83
     D*    HOLDS WORKSTATION ID
     D*
     D PSDS           SDS
     D  SWSID                244    253
     D  USRID                254    263

      ** Midas SF Valid action codes for user/brch/item Temporary File
     D SFMACBRFmt    E DS                  EXTNAME(GPWMACBRDD)
     D                                     PREFIX(SF)
     D  SFALLOW               23     32

      ** Midas SF Valid action codes for user/brch/item
     D MACBRDDFmt    E DS                  EXTNAME(GPMACBRDD)
     D RECIAC        E                     EXTFLD(RECI)
     D  ALLOW                 23     32


     I/SPACE 2
     I@MENUJ0
     I*    MIDAS MENU ITEMS FILE
     I*
     I              MISECL                      SECLIT
     I              MIAAC10                     MIAA10
     I              MIALLAC                     MIALLA
     I*
     IMBRBSDDF
     I*    MIDAS USER'S VALID BRANCH CODES
     I*
     I              RECI                        RECIBB
     IMACBRDDF
     I*    MIDAS USER'S VALID ACTION CODES
     I*
     I              RECI                        RECIAC
      *
      ** RECEIVE  USER PROFILE, ACTION CODE, RETURN CODE, UPDATE,
      ** RUN-DATE(2), MULTI-BRANCH INDICATOR  AND  USER'S SECURITY
      ** LEVEL AND INITIAL MENU GROUPS  PARAMETERS FROM CALLING PGM.
      *
     C     *ENTRY        PLIST
     C                   PARM                    USRPRF           10
     C                   PARM                    ACTCDE            1
     C                   PARM                    RTCDE             1 0
     C                   PARM                    UPDATE            1
     C                   PARM                    SRUNA             7
     C                   PARM                    RUNDD             5 0
     C                   PARM                    MBRIND            1
     C                   PARM                    SECLUS            4 0
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** KEY TO ACCESS LF/MACBR1 (USER'S VALID ACTION CODES BY BRANCH)
      *
     C     ACBRKY        KLIST
     C                   KFLD                    USRPK            10
     C                   KFLD                    BRCAK             3
     C                   KFLD                    INDXK            10
      *
     C     KYACBR        KLIST
     C                   KFLD                    KUSRP            10
     C                   KFLD                    KBRCA             3
      *
     C                   MOVEL     '*G'          LIBR              2
      *
     C/SPACE 2
      *
      ** SETUP SCREEN HEADING FIELDS
      *
     C                   MOVE      USRPRF        SUSER
     C                   MOVE      ACTCDE        SACTN
      *
     C                   MOVE      USRPRF        USRPK
     C/SPACE 2
      *
      ** CHECK ACTION CODE
      *
     C     ACTCDE        COMP      'I'                                    21
     C     ACTCDE        COMP      'A'                                    22
     C     ACTCDE        COMP      'E'                                    23
     C     ACTCDE        COMP      'D'                                    24
     C/SPACE 2
      *
      ** CHECK MULTIBRANCH INDICATOR
      *
     C     MBRIND        COMP      'Y'                                    70
      *
      ** NOT MULTI-BRANCH
      *
     C     *IN70         IFEQ      '0'
     C**                 MOVE      BJSBRC        BRCAK
     C                   EXSR      ACCDDT
      *
     C                   EXSR      ENDPGM
      *
      ** - MULTI-BRANCH
      *
     C                   ELSE
      *
     C     BRSEL         TAG
     C                   EXSR      BRSELC
      *
     C     B             IFEQ      0
     C                   EXSR      ENDPGM
      *
     C                   ELSE
     C                   Z-ADD     0             A                 4 0
      *
     C     A             DOUEQ     B
     C                   ADD       1             A
     C                   MOVE      BRU(A)        BRCAK
     C                   EXSR      ACCDDT
      *
     C     *INKB         CABEQ     '1'           BRSEL
      *
     C                   END
      *
     C                   GOTO      BRSEL
     C                   END
      *
     C                   END
     C/EJECT
      *****************************************************************
      *                                                               *
      * BRSELC    - HANDLE PROCESSING FOR THE BRANCH SELECTION        *
      *             SCREEN (ONLY DISPLAYED IF MULTI-BRNCH IND. = 'Y') *
      *                                                               *
      *****************************************************************
     C     BRSELC        BEGSR
      *
      ** Delete existing records in GPWMACBRDD
      *
     C                   EXSR      SrDelSfmac
      *
      ** LOAD SUBFILE
      *
     C                   EXSR      LODSF1
      *
      ** Display Screen
      *
      **   - SET ON DISPLAY SCREEN IND.
      *
     C                   SETON                                        10
      *
     C     *IN10         DOWEQ     '1'
      *
      ** - HEADINGS
      *
     C                   WRITE     GP100003F3
      *
      ** - SUBFILE
      *
     C                   EXFMT     GP100003F2
      ** RESET INDICATORS
     C                   SETOFF                                       041011
      *
      ** CHECK CMD/KEY PRESSED ON EXITING DISPLAY
      *
     C     *INKC         CASEQ     '1'           EXIT
     C     *INKL         CASEQ     '1'           INITSC
     C     *IN07         CASEQ     '0'           ENDPGM
     C                   CAS                     VBRSLC
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * LODSF1    - LOAD SUBFILE FOR THE BRANCH SELECTION SCREEN      *
      *                                                               *
      *****************************************************************
     C     LODSF1        BEGSR
      *
      ** SETUP SUBFILE CONTROL FIELDS
      *
     C                   Z-ADD     0             RRN1              4 0
     C                   Z-ADD     1             SDREC1
      *
      ** CLEAR SUBFILE
      *
     C                   MOVEA     '1001'        *IN(05)
     C                   WRITE     GP100003F2
     C                   MOVEA     '01'          *IN(05)
      *
      ** ACCESS GPMBRBS RECORD
      *
     C     USRPRF        CHAIN     GPMBRBS                            40
     C  N40RECIBB        COMP      'D'                                4040
      *
     C     *IN40         IFEQ      '0'
      *
     C     NOBR          IFNE      0
     C                   MOVEA     VBRX          BRU
     C                   Z-ADD     1             B                 4 0
      *
     C     '   '         LOOKUP    BRU(B)                             45
      *
     C     *IN45         IFEQ      '1'
      *
     C     B             DOWLE     900

      * Get branch details

     C     BRU(B)        CHAIN     SDBRCHD0                           75
     C     *IN75         IFEQ      *ON
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     BRU(B)        DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     *IN75         IFEQ      '0'
     C                   ADD       1             RRN1
     C                   MOVE      ' '           SSLCT
     C                   MOVE      BRU(B)        SBRCA
     C                   MOVE      A8BRNM        SBRNM
     C                   WRITE     GP100003F1
     C                   END
      *
     C                   ADD       1             B
      *
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   END
      *
      ** NO RECORDS IN SUBFILE
      *
     C     RRN1          IFNE      0
     C                   SETON                                        07
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * VBRSLC    - VALIDATE BRANCH SELECTIONS                        *
      *                                                               *
      *****************************************************************
     C     VBRSLC        BEGSR
      *
      ** RESET ARRAYS AND SUBFILE CONTROL FIELDS
      *
     C                   Z-ADD     0             X                 2 0
     C                   MOVE      *BLANK        ARR
     C                   Z-ADD     0             B
     C                   MOVE      *BLANK        BRU
      *
     C                   Z-ADD     0             RRN1
     C                   Z-ADD     1             SDREC1
      *
      ** VALIDATE SELECTION ENTRIES :-
      *
     C     *IN14         DOUEQ     '1'
      *
     C                   SETOFF                                       1213
     C                   SETON                                        09
      *
     C                   READC     GP100003F1                             14
      *
     C     *IN14         IFEQ      '0'
      *
     C                   MOVE      *BLANKS       SMSG
      *
      ** - INVALID ENTRY
      *
     C     SSLCT         IFNE      ' '
     C     SSLCT         ANDNE     'Y'
      *
     C                   SETON                                        12
      *
     C     *IN11         IFEQ      '0'
     C     X             ADD       1             X
     C                   MOVE      '060'         ARR(X)
      *
     C                   Z-ADD     RRN1          SDREC1
     C                   SETON                                        11
     C                   END
      *
     C                   ELSE
      *
      ** - VALID ENTRY
      *
     C     SSLCT         IFEQ      'Y'
      *
     C                   MOVE      SBRCA         BRCAK
     C                   MOVE      *BLANKS       INDXK
      *
     C     ACBRKY        SETLL     GPMACBR1
     C                   READ      GPMACBR1                               80
     C  N80BRCAK         COMP      BRCB                               8080
     C  N80USRPRF        COMP      USRP                               8080
      *
     C     *IN80         IFEQ      '1'
      *
     C     *IN23         IFEQ      '1'
     C     *IN24         OREQ      '1'
     C                   SETON                                        0413
     C                   MOVEL     MSG(1)        SMSG
      *
     C                   ELSE
     C                   ADD       1             B
     C                   MOVE      SBRCA         BRU(B)
     C                   END
      *
     C                   ELSE
      *
     C     RECIAC        COMP      'D'                                4242
      *
     C     *IN42         IFEQ      '1'
     C     *IN24         ANDEQ     '1'
     C                   SETON                                        0413
     C                   MOVEL     MSG(1)        SMSG
      *
     C                   ELSE
     C                   ADD       1             B
     C                   MOVE      SBRCA         BRU(B)
     C                   END
      *
     C                   END
      *
     C                   ELSE
     C                   SETOFF                                       09
      *
     C                   END
      *
     C                   END
      *
     C                   UPDATE    GP100003F1
      *
     C                   END
      *
     C                   END
      *
      ** IF ANY ERRORS, SET ON SCREEN INDICATOR
      *
     C     *IN04         IFEQ      '1'
     C     *IN11         OREQ      '1'
     C                   SETON                                        10
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * ACCDDT    - HANDLE PROCESSING FOR ACTION CODES                *
      *             DETAILS SCREEN                                    *
      *                                                               *
      *****************************************************************
     C     ACCDDT        BEGSR
      *
      ** Setoff the F13 indicator.
      *
     C                   EVAL      *IN71 = *OFF
     C                   EVAL      WHI = *BLANKS
      *
      ** SETUP BRANCH DISPLAY FIELD
      *
     C                   MOVE      BRCAK         SBRCA
      *
      ** SET PROCESSING FLAG TO FORCE SUBFILE REBUILD
      *
     C                   MOVEL     'RA'          AID               2
      *
      ** Initialize indicator.
      *
     C                   EVAL      *IN29 = *ON
      *
      ** D O
      *
     C                   DOW       AID <> *BLANKS
      *
      ** I F  R O L L   U P / D O W N   O R   E N T E R   P R E S S E D
      *
      ** R E B U I L D   S U B F I L E                     -  S T A R T
      *
     C                   EVAL      *IN16 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN17 = *OFF
     C                   Z-ADD     0             RRN2              4 0
     C                   WRITE     GP100003F5
     C                   EVAL      *IN34 = *OFF
      *
     C                   SETOFF                                       26
      *
      ** SET FILE POINTER - PAGE BACK
      *
     C                   IF        AID = 'DN'
     C                   MOVE      WTOPK         KEYFLDS
     C     SSNAM         SETLL     GPMTXTL3
      *
      ** Read previous subfile page if no selection is made.
      *
      ** WRITE CONTROL RECORD
      *
     C                   Z-ADD     *ZERO         I                 2 0
     C                   DOW       I < 12 AND *IN34 = *OFF
     C                   MOVE      *BLANK        WZONE
     C                   MOVE      *OFF          *IN38
     C     *IN34         DOWEQ     *OFF
     C     WZONE         ANDNE     LIBR
     C     *IN38         ANDEQ     *OFF
     C     *IN34         OREQ      *OFF
     C     WZONE         ANDEQ     LIBR
     C     *IN33         ANDEQ     *ON
     C     *IN34         OREQ      *OFF
     C     *IN38         ANDEQ     *ON
     C     *IN33         ANDEQ     *ON
     C                   READP     GPMTXTL3                               34
     C*****2             SUBST     MIINDX:1      WZONE             2                         BUG4091
     C*****              MOVEL     WZONE         WZONEN            3 0                       BUG4091
     C*****              MOVEL     WZONEN        WZONEA            2                         BUG4091
     C*****              MOVE      *OFF          *IN38                                       BUG4091
     C*****WZONE         IFEQ      WZONEA                                                    BUG4091
     C*****              MOVE      *ON           *IN38                                       BUG4091
     C*****              ENDIF                                                               BUG4091
     C*****MIINDX        CHAIN     GPMENUJ0                           33                     BUG4091
     C                   EXSR      ZONEEXTR                                                  BUG4091
     C                   ENDDO
      *
     C                   IF        *IN34 = *OFF
      *
     C     SECLIT        COMP      SECLUS                               5454
      *
      ** ITEM'S SECURITY LEVEL CANNOT BE GREATER THAN USER'S
      *
     C     *IN54         IFEQ      '1'
     C                   ADD       1             I
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        *IN34 = *ON
     C     *LOVAL        SETLL     GPMTXTL3
     C                   ENDIF
      *
      ** OTHERWISE        - PAGE FORWARD
      *
     C                   ELSE
     C     AID           IFEQ      'RA'
     C     *LOVAL        SETLL     GPMTXTL3
     C                   ELSE
     C     MISNAM        SETLL     GPMTXTL3
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** READ IN DETAILS-FILL UP SUBFILE
      *
     C                   DOU       RRN2 = 11 OR *IN82 = *ON
      *
      ** READ DETAILS UNTIL SUBFILE PAGE IS FULL
      *
     C                   MOVE      *OFF          *IN82
     C                   MOVE      *BLANK        WZONE
     C                   MOVE      *OFF          *IN38
     C     *IN82         DOWEQ     *OFF
     C     WZONE         ANDNE     LIBR
     C     *IN38         ANDEQ     *OFF
     C     *IN82         OREQ      *OFF
     C     WZONE         ANDEQ     LIBR
     C     *IN33         ANDEQ     *ON
     C     *IN82         OREQ      *OFF
     C     *IN38         ANDEQ     *ON
     C     *IN33         ANDEQ     *ON
     C                   READ      GPMTXTL3                               82
     C*****2             SUBST     MIINDX:1      WZONE             2                         BUG4091
     C*****              MOVEL     WZONE         WZONEN            3 0                       BUG4091
     C*****              MOVEL     WZONEN        WZONEA            2                         BUG4091
     C*****              MOVE      *OFF          *IN38                                       BUG4091
     C*****WZONE         IFEQ      WZONEA                                                    BUG4091
     C*****              MOVE      *ON           *IN38                                       BUG4091
     C*****              ENDIF                                                               BUG4091
     C*****MIINDX        CHAIN     GPMENUJ0                           33                     BUG4091
     C                   EXSR      ZONEEXTR                                                  BUG4091
     C                   ENDDO
      *
     C                   IF        *IN82 = *OFF
      *
     C     SECLIT        COMP      SECLUS                               5454
      *
      ** ITEM'S SECURITY LEVEL CANNOT BE GREATER THAN USER'S
      *
     C     *IN54         IFEQ      '1'
      *
      **   IF ALL OK, THEN WRITE A SUBFILE RECORD.
      *
     C                   EXSR      WRTSFR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** PAGE NOW FULL (OR EOF)
      *
     C                   ENDDO
      *
      ** READ ONE MORE RECORD FOR NEXT SCREEN
      *
     C                   MOVE      *BLANK        WZONE
     C                   MOVE      *OFF          *IN38
     C     *IN82         DOWEQ     *OFF
     C     WZONE         ANDNE     LIBR
     C     *IN38         ANDEQ     *OFF
     C     *IN82         OREQ      *OFF
     C     WZONE         ANDEQ     LIBR
     C     *IN33         ANDEQ     *ON
     C     *IN82         OREQ      *OFF
     C     *IN38         ANDEQ     *ON
     C     *IN33         ANDEQ     *ON
     C                   READ      GPMTXTL3                               82
     C*****2             SUBST     MIINDX:1      WZONE             2                         BUG4091
     C*****              MOVEL     WZONE         WZONEN            3 0                       BUG4091
     C*****              MOVEL     WZONEN        WZONEA            2                         BUG4091
     C*****              MOVE      *OFF          *IN38                                       BUG4091
     C*****WZONE         IFEQ      WZONEA                                                    BUG4091
     C*****              MOVE      *ON           *IN38                                       BUG4091
     C*****              ENDIF                                                               BUG4091
     C*****MIINDX        CHAIN     GPMENUJ0                           33                     BUG4091
     C                   EXSR      ZONEEXTR                                                  BUG4091
     C                   ENDDO
      *
     C                   DOU       *IN20 = *OFF
      *
      *
      ** FOR SUBFILE CONTROL
      *
     C                   IF        *IN29 = *ON
     C                   EVAL      *IN17 = *OFF
     C                   EVAL      *IN16 = *ON
     C                   EVAL      *IN82 = *OFF
     C                   ELSE
     C                   EVAL      *IN17 = *ON
     C                   EVAL      *IN16 = *ON
     C                   ENDIF
      *
      ** - HEADINGS
      *
     C                   WRITE     GP100003F6
      *
      ** - SUBFILE
      *
     C                   EXFMT     GP100003F5
      *
      ** RESET INDICATORS
      *
     C                   SETOFF                                       30
     C                   SETOFF                                       20
      *
     C     *IN70         IFEQ      '1'
     C     *INKB         ANDEQ     '1'
     C                   GOTO      ACEND
     C                   END
      *
      ** CHECK CMD/KEY PRESSED + ACTION CODE ON EXITING DISPLAY
      *
     C     *INKC         CASEQ     *ON           EXIT
     C     *INKL         CASEQ     *ON           INITSC
     C                   ENDCS
      *
     C     *IN17         CABEQ     *OFF          ACEND
      *
      ** ENTER PRESSED, PROCESS RECORD SELECTION
      *
     C     ACTCDE        CASEQ     'I'           INSAMD
     C     ACTCDE        CASEQ     'A'           INSAMD
     C     ACTCDE        CASEQ     'D'           DELETE
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   IF        *IN67 = *ON
     C                   EVAL      AID = 'UP'
     C                   ELSE
      *
     C                   IF        *IN68 = *ON
     C                   EVAL      AID = 'DN'
     C                   ELSE
     C                   IF        *IN71 = *ON
     C                   EVAL      AID = 'RA'
     C                   ELSE
     C                   EVAL      AID = *BLANKS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      *IN67 = *OFF
     C                   EVAL      *IN68 = *OFF
      *
     C                   ENDDO
      *
      ** Update MACBRDD
      *
     C                   IF        *IN21 = *ON OR *IN22 = *ON
     C                   EXSR      SrUpdMacbr
     C                   ENDIF
      *
     C     ACEND         ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * WRTSFR    - WRITE A SUBFILE RECORD FOR THE ACTION CODES       *
      *             DETAIL SCREEN                                     *
      *                                                               *
      *****************************************************************
     C     WRTSFR        BEGSR
      *
     C                   ADD       1             RRN2                     29
      *
     C                   MOVE      MISNAM        SSNAM
     C                   MOVEL     MIINAR        SINAR
     C                   MOVE      MIINDX        SINDX
      *
     C                   MOVE      MIINDX        INDXK
      *
     C                   MOVE      ' '           RECIAC
      *
      *
     C     ACBRKY        CHAIN     GPWMACBRDD                         43
     C     ACBRKY        CHAIN     GPMACBR1                           41
      *
     C     *IN41         IFEQ      '0'
     C     *IN23         ANDEQ     '1'
     C     RECIAC        ANDEQ     'C'
     C                   SETON                                        26
     C                   ENDIF
      *
     C     *IN43         IFEQ      '0'
     C                   MOVEA     SFALLOW       WRKC
      *
     C     SFRECI        IFEQ      '*'
     C                   EVAL      *IN72 = *ON
     C                   EVAL      *IN19 = *OFF
     C                   ELSE
      *
     C                   IF        SFALLOW <> *BLANKS
     C                   EVAL      *IN19 = *ON
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
     C     *IN41         IFEQ      '0'
     C                   MOVEA     ALLOW         WRKC
     C                   EVAL      *IN19 = *ON
     C                   ELSE
     C                   MOVEA     *BLANKS       WRKC
     C                   ENDIF
     C                   ENDIF
      *
      ** SET UP ARRAYS
      *
     C                   MOVEA     MIALLA        WRKB
     C                   MOVEA     *BLANKS       MITM
     C                   MOVEA     *BLANKS       MACB
      *
      ** LEFT ADJUST POSSIBLE ACTION CODES FROM GPMENUJ0
      *
     C                   Z-ADD     1             S                 2 0
     C                   Z-ADD     1             T                 2 0
     C     S             DOWLE     10
     C     S             ORLT      10
     C     WRKB(S)       COMP      ' '                                    62
     C  N62              MOVE      WRKB(S)       MITM(T)
     C  N62              ADD       1             T
     C                   ADD       1             S
     C                   ENDDO
     C                   MOVEA     MITM          SPACD
      *
      ** LEFT ADJUST ALLOWABLE ACTION CODES FROM MACBR
      *
     C                   Z-ADD     1             S
     C                   Z-ADD     1             T
     C     S             DOWLE     10
     C     S             ORLT      10
     C     WRKC(S)       COMP      ' '                                    63
     C  N63              MOVE      WRKC(S)       MACB(T)
     C  N63              ADD       1             T
     C                   ADD       1             S
     C                   ENDDO
     C                   MOVEA     MACB          SACAD
      *
     C                   IF        RRN2 = 1
     C                   MOVE      *BLANKS       WTOPK            85
     C                   MOVE      KEYFLDS       WTOPK
     C                   ENDIF
      *
     C                   WRITE     GP100003F4
      *
     C                   SETOFF                                       72
     C                   SETOFF                                       19
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * INSAMD    - HANDLE INSERTS + AMENDMENTS                       *
      *                                                               *
      *****************************************************************
     C     INSAMD        BEGSR
      *
      ** RESET ARRAYS AND SUBFILE CONTROL FIELDS
      *
     C                   Z-ADD     0             X                 2 0
     C                   MOVE      *BLANK        ARR
     C                   Z-ADD     0             C                 4 0
     C                   Z-ADD     0             CRRN
      *
     C                   Z-ADD     0             RRN2
      *
      ** VALIDATE SELECTION ENTRIES :-
      *
     C     *IN37         DOUEQ     '1'
      *
     C                   MOVEA     '00'          *IN(31)
      *
     C                   READC     GP100003F4                             37
      *
     C     *IN37         IFEQ      '0'
      *
      *
      ** MOVE ALLOWABLE/POSSIBLE ACTION CODES TO APPROPRIATE ARRAY
      ** TO CHECK USER AUTHORITY FOR THAT PARTICULAR ACTION CODE
      *
     C                   IF        *IN71                                                      256978
     C                   MOVE      *BLANK        SACAD                                        256978
     C                   MOVE      SPACD         SACAD                                        256978
     C                   ENDIF                                                                256978
     C                   MOVEA     SACAD         MACB
     C                   MOVEA     SPACD         MITM
     C                   Z-ADD     1             S
     C     S             DOWLE     10
     C     *IN31         ANDEQ     '0'
     C     S             ORLT      10
     C     *IN31         ANDEQ     '0'
     C     MACB(S)       COMP      ' '                                    64
     C  N64MACB(S)       LOOKUP    MITM                                   65
     C                   IF        NOT *IN71                                                  256978
     C  N64
     CANN65              MOVE      '1'           *IN31
     C   31              EXSR      ERROR
     C                   ENDIF                                                                256978
     C                   ADD       1             S
     C                   ENDDO
      *
      ** VALIDATE NO DUPLICATION OF ACTION CODE
      *
     C                   Z-ADD     1             S
     C     S             DOWLE     9
     C     *IN31         ANDEQ     '0'
     C     *IN32         ANDEQ     '0'
     C     S             ORLT      9
     C     *IN31         ANDEQ     '0'
     C     *IN32         ANDEQ     '0'
     C     MACB(S)       COMP      ' '                                    66
     C  N66S             ADD       1             U                 2 0
     C  N66MACB(S)       LOOKUP    MACB(U)                                32
     C   32              EXSR      ERROR
     C                   ADD       1             S
     C                   ENDDO
      *
     C     *IN31         IFEQ      '0'
     C     *IN32         ANDEQ     '0'
     C                   ADD       1             C
     C                   MOVE      RRN2          CRRN(C)
     C                   ENDIF
      *
     C                   UPDATE    GP100003F4
      *
      ** Setoff SFLNXTCHG
      *
     C                   SETOFF                                       19
      *
     C                   ENDIF
      *
     C                   ENDDO
     C/SPACE 2
      *
      ** IF ANY ERRORS, SET ON SCREEN INDICATOR
      *
     C     *IN30         IFEQ      '1'
      *
     C                   SETON                                        20
      *
     C                   ENDIF
      *
      ** IF VALID, UPDATE FILES :-
      *
     C                   Z-ADD     0             D                 4 0
      *
     C                   DO        C
      *
     C                   ADD       1             D
      *
     C     CRRN(D)       CHAIN     GP100003F4                         37
      *
     C                   MOVE      SINDX         INDXK
      *
     C     ACBRKY        CHAIN     GPWMACBRDD                         43
      *
     C                   MOVEL     SACAD         SFALLOW
      *
      ** UPDATE GPWMACBRDD
      *
     C                   Z-ADD     RUNDD         SFLCD
     C                   MOVE      ACTCDE        SFCHTP
     C                   TIME                    SFTIMEP           6 0
     C                   Z-ADD     SFTIMEP       SFLCT
      *
     C     *IN43         IFEQ      '1'
      *
      ** CHAIN FAIL - WRITE A NEW RECORD TO MACBR1
      *
     C                   MOVE      'D'           SFRECI
     C                   MOVE      USRPRF        SFUSRP
     C                   MOVE      BRCAK         SFBRCB
     C                   MOVE      INDXK         SFINDX
      *
     C                   WRITE     GPWMACBRDF
     C                   MOVE      'Y'           UPDATE
      *
     C                   ELSE
     C                   MOVE      'D'           SFRECI
      *
     C                   UPDATE    GPWMACBRDF
     C                   MOVE      'Y'           UPDATE
      *
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** F13 is pressed.
      *
     C                   IF        *IN71 = *ON AND *IN30 = *OFF
     C                   MOVE      'Y'           WHI               1
     C                   EXSR      SrFunc13
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * DELETE    - HANDLE DELETIONS                                  *
      *                                                               *
      *****************************************************************
     C     DELETE        BEGSR
      *
      ** CMD/10 PRESSED - UPDATE MACBR1 RECORDS TO 'NON-LIVE'
      *
     C     *INKJ         IFEQ      '1'
      *
     C                   MOVE      *BLANKS       INDXK
      *
     C     ACBRKY        SETLL     GPMACBR1
      *
     C                   READ      GPMACBR1                               41
     C  N41BRCAK         COMP      BRCB                               4141
     C  N41USRPRF        COMP      USRP                               4141
      *
     C     *IN41         DOWEQ     '0'
      *
     C                   DELETE    MACBRDDF
     C                   MOVE      'Y'           UPDATE
      *
     C                   READ      GPMACBR1                               41
     C  N41BRCAK         COMP      BRCB                               4141
     C  N41USRPRF        COMP      USRP                               4141
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SrFunc13  - Write Records to GPWMACBRDD for menu items not    *
      *             existing in MACBRDD.                              *
      *                                                               *
      *****************************************************************
     C     SrFunc13      BEGSR
      *
     C     *LOVAL        SETLL     GPMTXTL3
      *
      ** READ IN DETAILS-FILL UP SUBFILE
      *
     C                   DOU       *IN82 = *ON
     C                   MOVE      *OFF          *IN82
     C                   MOVE      *BLANK        WZONE
     C                   MOVE      *OFF          *IN38
     C     *IN82         DOWEQ     *OFF
     C     WZONE         ANDNE     LIBR
     C     *IN38         ANDEQ     *OFF
     C     *IN82         OREQ      *OFF
     C     WZONE         ANDEQ     LIBR
     C     *IN33         ANDEQ     *ON
     C     *IN82         OREQ      *OFF
     C     *IN38         ANDEQ     *ON
     C     *IN33         ANDEQ     *ON
     C                   READ      GPMTXTL3                               82
     C*****2             SUBST     MIINDX:1      WZONE             2                         BUG4091
     C*****              MOVEL     WZONE         WZONEN            3 0                       BUG4091
     C*****              MOVEL     WZONEN        WZONEA            2                         BUG4091
     C*****              MOVE      *OFF          *IN38                                       BUG4091
     C*****WZONE         IFEQ      WZONEA                                                    BUG4091
     C*****              MOVE      *ON           *IN38                                       BUG4091
     C*****              ENDIF                                                               BUG4091
     C*****MIINDX        CHAIN     GPMENUJ0                           33                     BUG4091
     C                   EXSR      ZONEEXTR                                                  BUG4091
     C                   ENDDO
      *
     C                   IF        *IN82 = *OFF
      *
     C     SECLIT        COMP      SECLUS                               5454
      *
      ** ITEM'S SECURITY LEVEL CANNOT BE GREATER THAN USER'S
      *
     C     *IN54         IFEQ      '1'
      *
      **   IF ALL OK, THEN WRITE A SUBFILE RECORD.
      *
     C                   EXSR      WRTFILRC
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** EOF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrUpdMacbr - Update MACBRDD                                   *
      *                                                               *
      *****************************************************************
     C     SrUpdMacbr    BEGSR
      *
      ** READ IN DETAILS-FILL WRITTEN IN GPWMACBRDD
      *
     C                   EVAL      KUSRP = USRPK
     C                   EVAL      KBRCA = BRCAK
     C     KYACBR        SETLL     GPWMACBRDD
     C     KYACBR        READE     GPWMACBRDD                             43
     C                   DOW       *IN43 = *OFF
     C                   EVAL      INDXK = SFINDX
     C     ACBRKY        CHAIN     GPMACBR1                           41
     C                   IF        SFALLOW <> *BLANKS
     C                   MOVEL     SFMACBRFmt    MACBRDDFmt
     C                   EVAL      RECIAC = 'D'
     C                   IF        *IN41 = *OFF
     C                   UPDATE    MACBRDDF
     C                   ELSE
     C                   WRITE     MACBRDDF
     C                   ENDIF
     C                   ELSE
     C                   IF        *IN41 = *OFF
     C                   DELETE    MACBRDDF
     C                   ENDIF
     C                   ENDIF
     C                   DELETE    GPWMACBRDD
     C     KYACBR        READE     GPWMACBRDD                             43
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrDelSfmac - Delete GPWMACBRDD                                *
      *                                                               *
      *****************************************************************
     C     SrDelSfmac    BEGSR
     C     *LOVAL        SETLL     GPWMACBRDD
     C                   READ      GPWMACBRDD                             43
     C                   DOW       *IN43 = *OFF
     C                   DELETE    GPWMACBRDD
     C                   READ      GPWMACBRDD                             43
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * WRTFILRC -  WRITE A FILE RECORD FOR THE ITEM NOT IN MACBRDD   *
      *                                                               *
      *****************************************************************
     C     WRTFILRC      BEGSR
      *
     C                   MOVE      MIINDX        INDXK
      *
     C     ACBRKY        CHAIN     GPWMACBRDD                         43
     C     ACBRKY        CHAIN     GPMACBR1                           41
      *
     C     *IN41         IFEQ      '1'
     C     *IN43         ANDEQ     '1'
     C     *IN43         OREQ      '0'
     C     SFALLOW       ANDEQ     *BLANKS
      *
     C                   MOVE      *BLANKS       ALLOW
      *
      ** SET UP ARRAYS
      *
     C                   MOVEA     MIALLA        WRKB
     C                   MOVEA     ALLOW         WRKC
     C                   MOVEA     *BLANKS       MITM
     C                   MOVEA     *BLANKS       MACB
      *
      ** LEFT ADJUST POSSIBLE ACTION CODES FROM GPMENUJ0
      *
     C                   Z-ADD     1             S                 2 0
     C                   Z-ADD     1             T                 2 0
     C     S             DOWLE     10
     C     S             ORLT      10
     C     WRKB(S)       COMP      ' '                                    62
     C  N62              MOVE      WRKB(S)       MITM(T)
     C  N62              ADD       1             T
     C                   ADD       1             S
     C                   ENDDO
     C                   MOVE      INDXK         SFINDX
     C                   MOVEA     MITM          SFALLOW
     C                   MOVE      '*'           SFRECI
     C                   MOVE      USRPRF        SFUSRP
     C                   MOVE      BRCAK         SFBRCB
     C                   Z-ADD     RUNDD         SFLCD
     C                   MOVE      ACTCDE        SFCHTP
     C                   TIME                    SFTIMEP           6 0
     C                   Z-ADD     SFTIMEP       SFLCT
      *
     C                   IF        *IN43 = *ON
     C                   WRITE     GPWMACBRDF
     C                   ELSE
     C                   UPDATE    GPWMACBRDF
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        *IN43 = *OFF AND SFALLOW <> *BLANKS
     C                   EVAL      SFRECI = 'D'
     C                   UPDATE    GPWMACBRDF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * ERROR                                                         *
      *                                                               *
      *****************************************************************
     C     ERROR         BEGSR
      *
     C   31'065 '        LOOKUP    ARR                                    27
     C   32'066 '        LOOKUP    ARR                                    28
     C     *IN27         IFEQ      '1'
     C     *IN28         OREQ      '1'
     C                   GOTO      DROP
     C                   END
      *
     C     X             ADD       1             X
     C   31              MOVEL     ' 065'        ARR(X)
     C   32              MOVEL     ' 066'        ARR(X)
      *
     C     DROP          TAG
     C                   SETON                                        30
     C                   SETON                                        19
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * EXIT      - CMD/3 TAKEN TO EXIT  "MIDAS USER'S MAINTENANCE    *
      *                                                               *
      *****************************************************************
     C     EXIT          BEGSR
      *
     C                   Z-ADD     1             RTCDE
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * INITSC    - CMD/12 TAKEN TO DISPLAY INITIAL SCREEN            *
      *                                                               *
      *****************************************************************
     C     INITSC        BEGSR
      *
     C                   Z-ADD     5             RTCDE
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * ENDPGM    - RETURNS TO CALLING PROGRAM                        *
      *                                                               *
      *****************************************************************
     C     ENDPGM        BEGSR
      *
     C                   Z-ADD     0             RTCDE
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR                                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C                   ENDSR
      ******************************************************************
     C/EJECT
      *****************************************************************                      BUG4091
      *                                                               *                      BUG4091
      * SrDelSfmac - Delete GPWMACBRDD                                *                      BUG4091
      *                                                               *                      BUG4091
      *****************************************************************                      BUG4091
     C     ZONEEXTR      BEGSR                                                               BUG4091
     C     2             SUBST     MIINDX:1      WZONE             2                         BUG4091
     C                   TESTN                   WZONE                38                     BUG4091
     C     MIINDX        CHAIN     GPMENUJ0                           33                     BUG4091
      *                                                                                      BUG4091
     C                   ENDSR                                                               BUG4091
      *****************************************************************                      BUG4091
**   MSG - ERROR MESSAGES
No action codes exist
