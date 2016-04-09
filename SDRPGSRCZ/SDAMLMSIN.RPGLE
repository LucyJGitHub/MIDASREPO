     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD AML trans. analysis mapping table maint')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDAMLMSIN - AML Transaction Analysis Mapping Table           *
      *              Maintenance                                      *
      *                                                               *
      *  Function:   This module maintains the mapping of the Midas   *
      *              account movements to the AML codes used to       *
      *              analyse the data.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CDL038             Date 10May05               *
      *  Prev Amend No. CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** AML Transation file by Midas Transaction Retail Type
     FSDAMLML3  UF A E           K DISK    INFSR(*PSSR) RENAME(SDAMLMD0:SDAMLD3)
     F                                     COMMIT
 
      ** AML Transation file by Deal Type/Sub-Type
     FSDAMLML4  UF A E           K DISK    INFSR(*PSSR) RENAME(SDAMLMD0:SDAMLD4)
     F                                     COMMIT
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  30 - Record Found Indicator                                  *
      *  31 - Record Found Indicator                                  *
      *  32 - Record Found Indicator                                  *
      *  33 - Record Found Indicator                                  *
      *                                                               *
      *  LR - Program Exit                                            *
      *                                                               *
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBrowse    - Display Browse Screen                          *
      *  SRReadBrw   - Read Browse Sub-File Record                    *
      *  SRUpdSFLBrw - Update Sub-File Record with Error              *
      *  SRRdsSFLBrw - Redisplay Sub-File                             *
      *  SRUpdFile   - Update Database File                           *
      *  *INZSR      - Initialisation                                 *
      *  *PSSR       - DB Error Processing                            *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
 
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             96     96
 
     D                 DS
     D ValidAMLArr                   35    DIM(9999) ASCEND
     D  WACTN                         1    OVERLAY(ValidAMLArr:1)
     D  WRTTY                         5    OVERLAY(ValidAMLArr:2)
     D  WDLTP                         2    OVERLAY(ValidAMLArr:7)
     D  WDLST                         2    OVERLAY(ValidAMLArr:9)
     D  WAMLT                        25    OVERLAY(ValidAMLArr:11)
     D  WDLTS                         4    OVERLAY(ValidAMLArr:7)
 
      ** Screen details DS
     D ScreenDS        DS            35
     D  PACTN                  1      1
     D  PRTTY                  2      6
     D  PDLTP                  7      8
     D  PDLST                  9     10
     D  PAMLT                 11     35
     D  PDLTS                  7     10
     D  CurScnDS               2     35
 
      ** Previous Screen details DS
     D PrvScnDS        DS            34
     D  PRTTYH                 1      5
     D  PDLTPH                 6      7
     D  PDLSTH                 8      9
     D  PAMLTH                10     34
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Indicator Array
     DIndicatorP       S               *   INZ(%ADDR(*IN))
 
      ** Parameter
     D PSFLACTN        S              2A
     D PDSPTYPE        S              1A
     D PRTTYKEY        S              5A
     D PDLTPKEY        S              2A
     D PDLSTKEY        S              2A
     D PACTNOK         S              1A
     D PRTTYOK         S              1A
     D PDLTPOK         S              1A
     D PDLSTOK         S              1A
     D PAMLTOK         S              1A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKI           S              1A
     D PINKL           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PMsgId          S              7A
     D PMsgFNm         S             10A
     D PMsgDesc        S             80A
     D PMsgFile        S             10A
 
      ** Work fields
     D Idx             S              3P 0
     D Vdx             S              3P 0
     D WIdx            S              3P 0
     D WErrCtr         S              3P 0
     D WSCRN           S              1A
     D WINKI           S              1A
     D WDSPTYPE        S              1A
 
      ** Key fields
     D KDLTP           S              2A
     D KDLST           S              2A
 
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
 
      ** Browse sub-file record (initial)
 
     C                   IF        WSCRN = 'B'
     C                   EXSR      SRBrowse
     C                   ENDIF
 
      ** Read Sub-file record
 
     C                   IF        WSCRN = 'R'
     C                   EXSR      SRReadBrw
     C                   ENDIF
 
      ** Update Sub-file record with error
 
     C                   IF        WSCRN = 'E'
     C                   EXSR      SRUpdSFlBrw
     C                   ENDIF
 
      ** Redisplay the subfile
 
     C                   IF        WSCRN = 'D'
     C                   EXSR      SRRdsSFlBrw
     C                   ENDIF
 
      ** Update database file
 
     C                   IF        WSCRN = 'U'
     C                   EXSR      SRUpdFile
     C                   ENDIF
 
      ** Terminate program
 
     C                   IF        WSCRN = 'T'
     C                   EVAL      *INLR = TRUE
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBrowse - Display Browse Screen                             *
      *                                                               *
      *****************************************************************
 
     C     SRBrowse      BEGSR
 
      ** Save screen display type indicator
 
     C                   EVAL      WDSPTYPE = PDSPTYPE
 
     C                   CALLB     'SDAMLMBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      'BS'          PSFLACTN
     C                   PARM                    PDSPTYPE
     C                   PARM      *BLANK        PACTN
     C                   PARM      *BLANK        PRTTY
     C                   PARM      *BLANK        PDLTP
     C                   PARM      *BLANK        PDLST
     C                   PARM      *BLANK        PAMLT
     C                   PARM                    PRTTYKEY
     C                   PARM                    PDLTPKEY
     C                   PARM                    PDLSTKEY
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKE
     C                   PARM      FALSE         PINKI
     C                   PARM      FALSE         PINKL
     C                   PARM                    PACTNOK
     C                   PARM                    PRTTYOK
     C                   PARM                    PDLTPOK
     C                   PARM                    PDLSTOK
     C                   PARM                    PAMLTOK
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *BLANK        PrvScnDS
 
     C                   SELECT
 
      ** Terminate program when F3 entered
 
     C                   WHEN      PINKC = TRUE
     C                   EVAL      WSCRN = 'T'
 
      ** F5 or F12 was pressed, rebuild subfile
 
     C                   WHEN      (PINKE = TRUE) OR (PINKL = TRUE)
     C                   EVAL      WSCRN = 'B'
 
      ** Reset valid data array
 
     C                   EVAL      Vdx = 0
     C                   EVAL      ValidAMLArr = *BLANKS
 
     C                   OTHER
 
      ** Read initial sub-file record
 
     C                   EVAL      WSCRN = 'R'
     C                   ENDSL
 
      ** F9 is pressed, set on work field
 
     C                   IF        PINKI = TRUE
     C                   EVAL      WINKI = TRUE
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadBrw - Read Initial Browse Sub-File Record              *
      *                                                               *
      *****************************************************************
 
     C     SRReadBrw     BEGSR
 
     C                   CALLB     'SDAMLMBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      'RE'          PSFLACTN
     C                   PARM                    PDSPTYPE
     C                   PARM      *BLANK        PACTN
     C                   PARM      *BLANK        PRTTY
     C                   PARM      *BLANK        PDLTP
     C                   PARM      *BLANK        PDLST
     C                   PARM      *BLANK        PAMLT
     C                   PARM                    PRTTYKEY
     C                   PARM                    PDLTPKEY
     C                   PARM                    PDLSTKEY
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKE
     C                   PARM      FALSE         PINKI
     C                   PARM      FALSE         PINKL
     C                   PARM                    PACTNOK
     C                   PARM                    PRTTYOK
     C                   PARM                    PDLTPOK
     C                   PARM                    PDLSTOK
     C                   PARM                    PAMLTOK
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *BLANK        PrvScnDS
 
      ** Validate Fields
 
     C                   IF        (PINKC = FALSE) AND (ScreenDS <> *BLANK)
 
     C                   CALLB     'SDAMLMVAL'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    PACTN
     C                   PARM                    PRTTY
     C                   PARM                    PDLTP
     C                   PARM                    PDLST
     C                   PARM                    PAMLT
     C                   PARM      'Y'           PACTNOK
     C                   PARM      'Y'           PRTTYOK
     C                   PARM      'Y'           PDLTPOK
     C                   PARM      'Y'           PDLSTOK
     C                   PARM      'Y'           PAMLTOK
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Check deletion during amendment of record
 
     C                   IF        (PACTN <> *BLANK) AND (PACTN = 'D') AND
     C                             (CurScnDS <> PrvScnDS) AND
     C                             (CurScnDS <> *BLANK) AND
     C                             (PrvScnDS <> *BLANK)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1ACTN'
     C                   EVAL      MsgIDArr(Idx) = 'USR9671'
     C                   EVAL      PACTNOK = 'N'
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      (PDSPTYPE = 'I') AND (WINKI = FALSE) OR
     C                             (WDSPTYPE = 'I') AND (WINKI = TRUE)
 
      ** Check if record already existing from the file and subfile for insert
 
     C                   IF        (PRTTY <> *BLANK) AND (PDLTP = *BLANK) AND
     C                             (PDLST = *BLANK)
     C     PRTTY         LOOKUP    WRTTY                                  31
 
     C     PRTTY         CHAIN     SDAMLML3                           32
 
     C                   IF        (*IN31 = TRUE) OR (*IN32 = FALSE)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1RTTY'
     C                   EVAL      MsgIDArr(Idx) = 'USR9674'
     C                   EVAL      PRTTYOK = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        (PDLTP <> *BLANK) AND (PDLST <> *BLANK) AND
     C                             (PRTTY = *BLANK)
     C     PDLTS         LOOKUP    WDLTS                                  31
 
     C                   EVAL      KDLTP = PDLTP
     C                   EVAL      KDLST = PDLST
     C     KDLTPST       CHAIN     SDAMLML4                           32
 
     C                   IF        (*IN31 = TRUE) OR (*IN32 = FALSE)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1DLTP'
     C                   EVAL      MsgIDArr(Idx) = 'USR9674'
     C                   EVAL      PDLTPOK = 'N'
     C                   EVAL      PDLSTOK = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      (PDSPTYPE = 'A') AND (WINKI = FALSE) OR
     C                             (WDSPTYPE = 'A') AND (WINKI = TRUE)
 
      ** Check if record not existing for delete or amend
 
     C                   IF        (PRTTY <> *BLANK) AND (PDLTP = *BLANK) AND
     C                             (PDLST = *BLANK)
 
     C     PRTTY         CHAIN     SDAMLML3                           31
 
     C                   IF        *IN31 = TRUE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1RTTY'
     C                   IF        PACTN = 'D'
     C                   EVAL      MsgIDArr(Idx) = 'USR9673'
     C                   ELSE
     C                   EVAL      MsgIDArr(Idx) = 'USR9672'
     C                   ENDIF
     C                   EVAL      PACTNOK = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        (PDLTP <> *BLANK) AND (PDLST <> *BLANK) AND
     C                             (PRTTY = *BLANK)
 
     C                   EVAL      KDLTP = PDLTP
     C                   EVAL      KDLST = PDLST
 
     C     KDLTPST       CHAIN     SDAMLML4                           31
 
     C                   IF        *IN31 = TRUE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1DLTP'
     C                   IF        PACTN = 'D'
     C                   EVAL      MsgIDArr(Idx) = 'USR9673'
     C                   ELSE
     C                   EVAL      MsgIDArr(Idx) = 'USR9672'
     C                   ENDIF
     C                   EVAL      PACTNOK = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
      ** Error validating screen fields update subfile record
 
     C                   IF        Idx <> 0
     C                   EVAL      WSCRN = 'E'
     C                   EVAL      WErrCtr = WErrCtr + 1
 
      ** Put the screen back to the previous when F9 is pressed and an error
      ** occured
 
     C                   IF        WINKI = TRUE
     C                   IF        PDSPTYPE = 'A'
     C                   EVAL      PDSPTYPE = 'I'
     C                   ELSE
     C                   EVAL      PDSPTYPE = 'A'
     C                   ENDIF
     C                   EVAL      WINKI = FALSE
     C                   ENDIF
 
      ** Save valid data to array
 
     C                   ELSE
     C                   IF        (WDSPTYPE = 'I') OR
     C                             (WDSPTYPE = 'A') AND
     C                             (CurScnDS <> PrvScnDS) OR
     C                             (WDSPTYPE = 'A') AND (PACTN = 'D') AND
     C                             (CurScnDS = PrvScnDS)
     C                   EVAL      Vdx = Vdx + 1
     C                   EVAL      ValidAMLArr(Vdx) = ScreenDS
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** No subfile change or end of file
 
     C                   IF        (PINKC = FALSE) AND (ScreenDS = *BLANK)
 
      ** Found errors, redisplay subfile otherwise update the database
 
     C                   IF        WErrCtr <> 0
     C                   EVAL      WSCRN = 'D'
     C                   EVAL      WErrCtr = 0
 
      ** Reset error index
 
     C                   EVAL      Idx = 0
     C                   ELSE
     C                   IF        WINKI = TRUE
     C                   EVAL      WINKI = FALSE
     C                   ENDIF
     C                   IF        Vdx = 0
     C                   EVAL      WSCRN = 'B'
     C                   ELSE
     C                   EVAL      WSCRN = 'U'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdSFLBrw - Update Sub-File Record with Error              *
      *                                                               *
      *****************************************************************
 
     C     SRUpdSFLBrw   BEGSR
 
     C                   CALLB     'SDAMLMBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      'UP'          PSFLACTN
     C                   PARM                    PDSPTYPE
     C                   PARM                    PACTN
     C                   PARM                    PRTTY
     C                   PARM                    PDLTP
     C                   PARM                    PDLST
     C                   PARM                    PAMLT
     C                   PARM                    PRTTYKEY
     C                   PARM                    PDLTPKEY
     C                   PARM                    PDLSTKEY
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKE
     C                   PARM      FALSE         PINKI
     C                   PARM      FALSE         PINKL
     C                   PARM                    PACTNOK
     C                   PARM                    PRTTYOK
     C                   PARM                    PDLTPOK
     C                   PARM                    PDLSTOK
     C                   PARM                    PAMLTOK
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *BLANK        PrvScnDS
 
      ** Read next change
 
     C                   EVAL      WSCRN = 'R'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdsSFLBrw - Redisplay Sub-File                             *
      *                                                               *
      *****************************************************************
 
     C     SRRdsSFLBrw   BEGSR
 
      ** Save screen display type indicator
 
     C                   EVAL      WDSPTYPE = PDSPTYPE
 
     C                   CALLB     'SDAMLMBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      'RD'          PSFLACTN
     C                   PARM                    PDSPTYPE
     C                   PARM      *BLANK        PACTN
     C                   PARM      *BLANK        PRTTY
     C                   PARM      *BLANK        PDLTP
     C                   PARM      *BLANK        PDLST
     C                   PARM      *BLANK        PAMLT
     C                   PARM                    PRTTYKEY
     C                   PARM                    PDLTPKEY
     C                   PARM                    PDLSTKEY
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKE
     C                   PARM      FALSE         PINKI
     C                   PARM      FALSE         PINKL
     C                   PARM                    PACTNOK
     C                   PARM                    PRTTYOK
     C                   PARM                    PDLTPOK
     C                   PARM                    PDLSTOK
     C                   PARM                    PAMLTOK
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *BLANK        PrvScnDS
 
     C                   SELECT
 
      ** Terminate program when F3 entered
 
     C                   WHEN      PINKC = TRUE
     C                   EVAL      WSCRN = 'T'
 
      ** F5 or F12 was pressed, rebuild subfile
 
     C                   WHEN      (PINKE = TRUE) OR (PINKL = TRUE)
     C                   EVAL      WSCRN = 'B'
 
      ** Reset valid data array
 
     C                   EVAL      Vdx = 0
     C                   EVAL      ValidAMLArr = *BLANKS
 
     C                   OTHER
 
      ** Read initial sub-file record
 
     C                   EVAL      WSCRN = 'R'
 
      ** F9 is pressed, set on work field
 
     C                   IF        PINKI = TRUE
     C                   EVAL      WINKI = TRUE
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdFile -  Update Database File                            *
      *                                                               *
      *****************************************************************
 
     C     SRUpdFile     BEGSR
 
      ** Update database file
 
     C                   EVAL      Vdx = 1
 
     C                   DOW       ValidAMLArr(Vdx) <> *BLANK
 
     C                   EVAL      W6LCD = BJRDNB
 
     C                   SELECT
 
     C                   WHEN      WDSPTYPE = 'A'
 
     C                   EVAL      W6TYLC = 'A'
 
     C                   IF        WACTN(Vdx) <> 'D'
     C                   IF        WRTTY(Vdx) <> *BLANK
     C     WRTTY(Vdx)    CHAIN     SDAMLML3                           30
 
      ** No record found, display a warning error
 
     C                   IF        *IN30 = TRUE
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WMsgIdArr(WIdx) = 'USR9675'
     C                   EVAL      WMsgDtaArr(WIdx) = WRTTY(Vdx) + WDLTP(Vdx) +
     C                                                WDLST(Vdx)
     C                   ELSE
     C                   EVAL      W6RTTY = WRTTY(Vdx)
     C                   EVAL      W6DLTP = WDLTP(Vdx)
     C                   EVAL      W6DLST = WDLST(Vdx)
     C                   EVAL      W6AMLT = WAMLT(Vdx)
     C                   UPDATE    SDAMLD3
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      KDLTP = WDLTP(Vdx)
     C                   EVAL      KDLST = WDLST(Vdx)
     C     KDLTPST       CHAIN     SDAMLML4                           30
 
      ** No record found, display a warning error
 
     C                   IF        *IN30 = TRUE
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WMsgIdArr(WIdx) = 'USR9675'
     C                   EVAL      WMsgDtaArr(WIdx) = WRTTY(Vdx) + WDLTP(Vdx) +
     C                                                WDLST(Vdx)
     C                   ELSE
     C                   EVAL      W6RTTY = WRTTY(Vdx)
     C                   EVAL      W6DLTP = WDLTP(Vdx)
     C                   EVAL      W6DLST = WDLST(Vdx)
     C                   EVAL      W6AMLT = WAMLT(Vdx)
     C                   UPDATE    SDAMLD4
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WACTN(Vdx) = 'D'
     C                   IF        WRTTY(Vdx) <> *BLANK
     C     WRTTY(Vdx)    CHAIN     SDAMLML3                           30
 
      ** No record found, display a warning error
 
     C                   IF        *IN30 = TRUE
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WMsgIdArr(WIdx) = 'USR9676'
     C                   EVAL      WMsgDtaArr(WIdx) = WRTTY(Vdx) + WDLTP(Vdx) +
     C                                                WDLST(Vdx)
     C                   ELSE
     C                   DELETE    SDAMLD3
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      KDLTP = WDLTP(Vdx)
     C                   EVAL      KDLST = WDLST(Vdx)
     C     KDLTPST       CHAIN     SDAMLML4                           30
 
      ** No record found, display a warning error
 
     C                   IF        *IN30 = TRUE
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WMsgIdArr(WIdx) = 'USR9676'
     C                   EVAL      WMsgDtaArr(WIdx) = WRTTY(Vdx) + WDLTP(Vdx) +
     C                                                WDLST(Vdx)
     C                   ELSE
     C                   DELETE    SDAMLD4
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      WDSPTYPE = 'I'
 
     C                   EVAL      W6TYLC = 'I'
 
     C                   IF        WRTTY(Vdx) <> *BLANK
     C     WRTTY(Vdx)    CHAIN     SDAMLML3                           30
 
      ** Record already existing, display a warning error
 
     C                   IF        *IN30 = FALSE
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WMsgIdArr(WIdx) = 'USR9677'
     C                   EVAL      WMsgDtaArr(WIdx) = WRTTY(Vdx) + WDLTP(Vdx) +
     C                                                WDLST(Vdx)
     C                   ELSE
     C                   EVAL      W6RTTY = WRTTY(Vdx)
     C                   EVAL      W6DLTP = WDLTP(Vdx)
     C                   EVAL      W6DLST = WDLST(Vdx)
     C                   EVAL      W6AMLT = WAMLT(Vdx)
     C                   WRITE     SDAMLD3
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      KDLTP = WDLTP(Vdx)
     C                   EVAL      KDLST = WDLST(Vdx)
     C     KDLTPST       CHAIN     SDAMLML4                           30
 
      ** No record found, display a warning error
 
     C                   IF        *IN30 = FALSE
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WMsgIdArr(WIdx) = 'USR9677'
     C                   EVAL      WMsgDtaArr(WIdx) = WRTTY(Vdx) + WDLTP(Vdx) +
     C                                                WDLST(Vdx)
     C                   ELSE
     C                   EVAL      W6RTTY = WRTTY(Vdx)
     C                   EVAL      W6DLTP = WDLTP(Vdx)
     C                   EVAL      W6DLST = WDLST(Vdx)
     C                   EVAL      W6AMLT = WAMLT(Vdx)
     C                   WRITE     SDAMLD4
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
      ** Get next valid record
 
     C                   EVAL      Vdx = Vdx + 1
     C                   ENDDO
 
      ** Clear valid data array
 
     C                   EVAL      Vdx = 0
     C                   EVAL      WIdx = 0
     C                   EVAL      ValidAMLArr = *BLANKS
 
      ** Commit changes
 
     C                   COMMIT
 
      ** Build subfile screen
 
     C                   EVAL      WSCRN = 'B'
 
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
 
      ** Initialize program name
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAMLMSIN'   DBPGM
     C                   OUT       LDA
 
      ** Access bank detail
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key list
 
     C     KDLTPST       KLIST
     C                   KFLD                    KDLTP
     C                   KFLD                    KDLST
 
      ** Initialise function key parameters and other parameters/work fields
 
     C                   EVAL      PINKC = FALSE
     C                   EVAL      PINKE = FALSE
     C                   EVAL      PINKI = FALSE
     C                   EVAL      PINKL = FALSE
     C                   EVAL      PSFLACTN = 'BS'
     C                   EVAL      PDSPTYPE = 'A'
     C                   EVAL      PRTTYKEY = *BLANK
     C                   EVAL      PDLTPKEY = *BLANK
     C                   EVAL      PDLSTKEY = *BLANK
     C                   EVAL      PACTNOK = 'Y'
     C                   EVAL      PRTTYOK = 'Y'
     C                   EVAL      PDLTPOK = 'Y'
     C                   EVAL      PDLSTOK = 'Y'
     C                   EVAL      PAMLTOK = 'Y'
     C                   EVAL      Idx = *ZERO
     C                   EVAL      WIdx = *ZERO
     C                   EVAL      Vdx = *ZERO
     C                   EVAL      WErrCtr = *ZERO
     C                   EVAL      WSCRN = 'B'
     C                   EVAL      ValidAMLArr = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
