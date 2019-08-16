     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit Report')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUZRPT - Audit Report                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD053808           Date 07Aug19               *
      *  Prev Amend No. MD050279           Date 06Apr18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD043639           Date 27Jan17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053808 - COB Component GOC0310 fails due to field size     *
      *             too small.                                        *
      *  MD050279 - Generate empty reports with 'NO DATA' when        *
      *             no record in GPAUCHPD.                            *
      *  MD046248 - Finastra Rebranding                               *
      *  MD043639 - Audit report name is same for all functions.      *
      *             Fix is to rename the Audit report according to    *
      *             function being audited. Patterned after MD026634  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************

     FGPAUCHPD  IP   E           K DISK    INFSR(*PSSR)
     FGPAUIPPD  IF   E           K DISK    INFSR(*PSSR)
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGPAUZRPTP1O    F  132        PRINTER USROPN
     F                                     INFDS(SPOOL1)


      * Field Attributes
      * Field Shortnames
      * Field Descriptions
     D/COPY GPCPYSRCG,GPAUFDATB
     D/COPY GPCPYSRCG,GPAUFDSNM
     D/COPY GPCPYSRCG,GPAUFDDES


      * Field Contents
     D/COPY GPCPYSRCG,GPAUFDCON


     D ArFDCON         S              1    DIM(100)


     D TOT             S            132    DIM(150)
     D TOTC            S            132    DIM(150)
     D LIN             S              1    DIM(132) ASCEND
     D #AINPT          S              4    DIM(9999) ASCEND                                 MD050279
     D #ABRCD          S              3    DIM(9999) ASCEND                                 MD050279


     D MON             S              3    DIM(12) CTDATA PERRCD(12)


     D                 DS
     D  YYMMDD                 1      6
     D  YY                     1      2  0
     D  MM                     3      4  0
     D  DD                     5      6  0


      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1


      ** File Information Data Structure for GPAUZRPTP1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0

     D***qcOvr**                    128                                            MD043639 MD053808
     D***qcLen**                    15P 5                                          MD043639 MD053808
     DqcOvr            S            128                                                     MD053808
     DqcLen            S             15P 5                                                  MD053808
                                                                                            MD043639
      ** System value Audit Report Rename                                                   MD043639
     D SysVal1         C                   'AuditRptRename'                                 MD043639
      ** Parameters for GPAOSVALR0                                                          MD043639
     D PRtcd           S              7A                                                    MD043639
     D PSValK1         S             20A                                                    MD043639
     D PSValK2         S             20A                                                    MD043639
     D PSValK3         S             20A                                                    MD043639
     D PSValK4         S             20A                                                    MD043639
     D PSValK5         S             20A                                                    MD043639
     D PSValK6         S             20A                                                    MD043639
     D PSValK7         S             20A                                                    MD043639
     D PSValK8         S             20A                                                    MD043639
     D PSValK9         S             20A                                                    MD043639
     D PSValK10        S             20A                                                    MD043639
     D PSVal1          S            200A                                                    MD043639
     D PSVal2          S            200A                                                    MD043639
     D PSVal3          S            200A                                                    MD043639
     D PSVal4          S            200A                                                    MD043639
     D PSVal5          S            200A                                                    MD043639
     D PSVal6          S            200A                                                    MD043639
     D PSVal7          S            200A                                                    MD043639
     D PSVal8          S            200A                                                    MD043639
     D PSVal9          S            200A                                                    MD043639
     D PSVal10         S            200A                                                    MD043639
      *                                                                                     MD053808
      ** System value No Data Report Generation                                             MD053808
      *                                                                                     MD053808
     D SysVal@         C                   'GenAuRptNoDtaChg'                               MD053808
      *                                                                                     MD053808
      ** Parameter Variables to call 'AOSVALR0'                                             MD053808
      *                                                                                     MD053808
     D PRtcd@          S              7A                                                    MD053808
     D P@OP01          S             20A                                                    MD053808
     D P@OP02          S             20A                                                    MD053808
     D P@OP03          S             20A                                                    MD053808
     D P@OP04          S             20A                                                    MD053808
     D P@OP05          S             20A                                                    MD053808
     D P@OP06          S             20A                                                    MD053808
     D P@OP07          S             20A                                                    MD053808
     D P@OP08          S             20A                                                    MD053808
     D P@OP09          S             20A                                                    MD053808
     D P@OP10          S             20A                                                    MD053808
     D P@VL01          S            200A                                                    MD053808
     D P@VL02          S            200A                                                    MD053808
     D P@VL03          S            200A                                                    MD053808
     D P@VL04          S            200A                                                    MD053808
     D P@VL05          S            200A                                                    MD053808
     D P@VL06          S            200A                                                    MD053808
     D P@VL07          S            200A                                                    MD053808
     D P@VL08          S            200A                                                    MD053808
     D P@VL09          S            200A                                                    MD053808
     D P@VL10          S            200A                                                    MD053808
      *                                                                                     MD053808

     IGPAUCHD0
     I                                          AHBRCA        L2
     I                                          AHINPT        L1

      * Change of branch or input

     C   L1              EXSR      CHG_BRCA_INPT

      * Create reporting date from machine date in YYMMDD format

     C                   EXSR      REPORT_DATE

      * Output change headings
      * =====================

     C                   Z-ADD     4             NoOfOutLines      3 0
     C                   MOVEL     *BLANK        R_REFI           53
     C                   EVAL      R_REFI = AHREFI
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    CHANGEID

      * Audit Field Attributes - Retrieval
      * Audit Change Details - Retrieval

     C                   EXSR      AUFD_RTL
     C                   EXSR      AUCD_RTL

      * Outputs

     C                   SELECT
     C     AHENTT        WHENEQ    'PT'
     C                   EXSR      OUT_PT
     C     AHENTT        WHENEQ    'DL'
     C                   EXSR      OUT_DL
     C                   OTHER
     C                   EXSR      OUT_UP
     C                   ENDSL

     CLR                 EXSR      END_REPT
      /SPACE 5
      ****************************************************************
      * Output PT
      ****************************************************************
     C     OUT_PT        BEGSR

      * Output 'AFTER' image

     C                   MOVEL     'A'           Before_After      1

     C                   MOVE      *BLANK        TOT
     C                   MOVE      *BLANK        TOTC
     C**********         Z-ADD     1             HLN               2 0                      MD043639
     C                   Z-ADD     1             HLN               3 0                      MD043639

     C                   EXSR      LOAD_NARR
     C                   EXSR      LOAD_FLDS

     C                   Z-ADD     1             OLN               3 0
     C     OLN           DOWLE     HLN
     C                   Z-ADD     1             NoOfOutLines
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    REPORTLINE
     C                   EXCEPT    REPORTLINC
     C                   ADD       1             OLN
     C                   ENDDO

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Output DL
      ****************************************************************
     C     OUT_DL        BEGSR

      * Output 'BEFORE' image

     C                   MOVEL     'B'           Before_After      1

     C                   MOVE      *BLANK        TOT
     C                   MOVE      *BLANK        TOTC
     C**********         Z-ADD     1             HLN               2 0                      MD043639
     C                   Z-ADD     1             HLN               3 0                      MD043639

     C                   EXSR      LOAD_NARR
     C                   EXSR      LOAD_FLDS

     C                   Z-ADD     1             OLN               3 0
     C     OLN           DOWLE     HLN
     C                   Z-ADD     1             NoOfOutLines
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    REPORTLINE
     C                   EXCEPT    REPORTLINC
     C                   ADD       1             OLN
     C                   ENDDO

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Output UP
      ****************************************************************
     C     OUT_UP        BEGSR

      * Output 'AFTER' image

     C                   MOVEL     'A'           Before_After      1

     C     AHACTN        IFEQ      'AMEND'
     C                   Z-ADD     1             NoOfOutLines
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    AFTERNARR
     C                   ENDIF

     C                   MOVE      *BLANK        TOT
     C                   MOVE      *BLANK        TOTC
     C**********         Z-ADD     1             HLN               2 0                      MD043639
     C                   Z-ADD     1             HLN               3 0                      MD043639

     C                   EXSR      LOAD_NARR
     C                   EXSR      LOAD_FLDS

     C                   Z-ADD     1             OLN               3 0
     C     OLN           DOWLE     HLN
     C                   Z-ADD     1             NoOfOutLines
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    REPORTLINE
     C                   EXCEPT    REPORTLINC
     C                   ADD       1             OLN
     C                   ENDDO

      * Output 'BEFORE' image (if amend)

     C     AHACTN        IFEQ      'AMEND'

     C                   MOVEL     'B'           Before_After      1

     C                   Z-ADD     1             NoOfOutLines
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    BEFORENARR

     C                   MOVE      *BLANK        TOT
     C                   MOVE      *BLANK        TOTC
     C**********         Z-ADD     1             HLN               2 0                      MD043639
     C                   Z-ADD     1             HLN               3 0                      MD043639

     C                   EXSR      LOAD_NARR
     C                   EXSR      LOAD_FLDS

     C                   Z-ADD     1             OLN               3 0
     C     OLN           DOWLE     HLN
     C     TOTC(OLN)     IFNE      *BLANK
     C                   Z-ADD     1             NoOfOutLines
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    REPORTLINE
     C                   EXCEPT    REPORTLINC
     C                   ENDIF
     C                   ADD       1             OLN
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Change of branch or input
      ****************************************************************
     C     CHG_BRCA_INPT BEGSR

     C     GenReport     IFEQ      'Y'                                                      MD053808
                                                                                            MD053808
      * If a branch is 'skipped', generate all reports for that branch with 'NO DATA'       MD050279
     C     *INL2         IFEQ      *ON                                                      MD050279
     C     AHBRCA        ANDNE     *BLANKS                                                  MD050279
                                                                                            MD050279
     C     AHBRCA        DOWNE     #ABRCD(#XB)                                              MD050279
     C     #ABRCD(#XB)   ANDNE     *BLANKS                                                  MD050279
      * Save current branch                                                                 MD050279
     C                   MOVEL     AHBRCA        SAV_AHBRCA        3                        MD050279
     C     #ABRCD(#XB)   CHAIN     SDBRCHD0                           60                    MD050279
      * for new branch reset file pointer                                                   MD050279
     C                   Z-ADD     1             #XF                                        MD050279
                                                                                            MD050279
     C                   DOW       #AINPT(#XF) <> *BLANKS                                   MD050279
     C                   MOVEL     #AINPT(#XF)   ##INPT            4                        MD050279
                                                                                            MD050279
     C     Printf_Open   IFEQ      'Y'                                                      MD050279
     C                   Z-ADD     3             NoOfOutLines                               MD050279
     C                   EXSR      PAGE_CHG_CHK                                             MD050279
     C                   EXCEPT    ENDREPORT                                                MD050279
     C                   CLOSE     GPAUZRPTP1                                               MD050279
     C                   EVAL      PrintF_Open = 'N'                                        MD050279
     C                   ENDIF                                                              MD050279
      *                                                                                     MD050279
     C                   IF        AURename = 'Y'                                           MD050279
     C                   EVAL      qcOvr='OVRPRTF FILE(GPAUZRPTP1) TOFILE(*LIBL'            MD050279
     C                   EVAL      qcOvr=%Trim(qcOvr)+'/GPAUZRPTP1) SPLFNAME('              MD050279
     C                   EVAL      qcOvr=%Trim(qcOvr)+'GPAU'+%Trim(##INPT)+'P1)'            MD050279
     C                   EVAL      qcLen=%Len(%Trim(qcOvr))                                 MD050279
     C                   CALL      'QCMDEXC'                                                MD050279
     C                   PARM                    qcOvr                                      MD050279
     C                   PARM                    qcLen                                      MD050279
     C                   ENDIF                                                              MD050279
      *                                                                                     MD050279
     C     #AINPT(#XF)   CHAIN     GPAUIPD0                           99                    MD050279
     C                   OPEN      GPAUZRPTP1                                               MD050279
     C                   EXSR      SRRCFP1                                                  MD050279
     C                   Z-ADD     99            LineNumber                                 MD050279
     C                   Z-ADD     1             PageNumber                                 MD050279
     C                   EXCEPT    PAGEHEAD                                                 MD050279
     C                   EXCEPT    NODATA                                                   MD050279
     C                   CLOSE     GPAUZRPTP1                                               MD050279
     C                   ADD       1             #XF                                        MD050279
     C                   ENDDO                                                              MD050279
     C                                                                                      MD050279
      * Restore current branch                                                              MD050279
     C                   MOVEL     SAV_AHBRCA    AHBRCA                                     MD050279
     C                   ADD       1             #XB                                        MD050279
     C                   ENDDO                                                              MD050279
     C                   ENDIF                                                              MD050279
                                                                                            MD050279
      * When branch is changed, generate rest of reports for previous branch                MD050279
     C     *INL2         IFEQ      *ON                                                      MD050279
     C     AHBRCA        ANDNE     *BLANKS                                                  MD050279
     C     AHBRCA        ANDEQ     #ABRCD(#XB)                                              MD050279
      * this should not be done when previous branch is blank                               MD050279
     C     #XB           ANDNE     1                                                        MD050279
                                                                                            MD050279
      * Save current branch first                                                           MD050279
     C                   MOVEL     AHBRCA        SAV_AHBRCA        3                        MD050279
      * and replave with previous branch                                                    MD050279
     C                   MOVEL     PREV_BRCA     AHBRCA                                     MD050279
                                                                                            MD050279
     C                   DOW       #AINPT(#XF) <> *BLANKS                                   MD050279
     C                   MOVEL     #AINPT(#XF)   ##INPT            4                        MD050279
                                                                                            MD050279
     C     Printf_Open   IFEQ      'Y'                                                      MD050279
     C                   Z-ADD     3             NoOfOutLines                               MD050279
     C                   EXSR      PAGE_CHG_CHK                                             MD050279
     C                   EXCEPT    ENDREPORT                                                MD050279
     C                   CLOSE     GPAUZRPTP1                                               MD050279
     C                   EVAL      PrintF_Open = 'N'                                        MD050279
     C                   ENDIF                                                              MD050279
      *                                                                                     MD050279
     C                   IF        AURename = 'Y'                                           MD050279
     C                   EVAL      qcOvr='OVRPRTF FILE(GPAUZRPTP1) TOFILE(*LIBL'            MD050279
     C                   EVAL      qcOvr=%Trim(qcOvr)+'/GPAUZRPTP1) SPLFNAME('              MD050279
     C                   EVAL      qcOvr=%Trim(qcOvr)+'GPAU'+%Trim(##INPT)+'P1)'            MD050279
     C                   EVAL      qcLen=%Len(%Trim(qcOvr))                                 MD050279
     C                   CALL      'QCMDEXC'                                                MD050279
     C                   PARM                    qcOvr                                      MD050279
     C                   PARM                    qcLen                                      MD050279
     C                   ENDIF                                                              MD050279
      *                                                                                     MD050279
     C     #AINPT(#XF)   CHAIN     GPAUIPD0                           99                    MD050279
     C                   OPEN      GPAUZRPTP1                                               MD050279
     C                   EXSR      SRRCFP1                                                  MD050279
     C                   Z-ADD     99            LineNumber                                 MD050279
     C                   Z-ADD     1             PageNumber                                 MD050279
     C                   EXCEPT    PAGEHEAD                                                 MD050279
     C                   EXCEPT    NODATA                                                   MD050279
     C                   CLOSE     GPAUZRPTP1                                               MD050279
     C                   ADD       1             #XF                                        MD050279
     C                   ENDDO                                                              MD050279
     C                                                                                      MD050279
      * for new branch reset file pointer                                                   MD050279
     C                   Z-ADD     1             #XF                                        MD050279
     C                   ADD       1             #XB                                        MD050279
      * Restore current branch                                                              MD050279
     C                   MOVEL     SAV_AHBRCA    AHBRCA                                     MD050279
     C                   ENDIF                                                              MD050279
                                                                                            MD050279
     C     *INL2         IFEQ      *ON                                                      MD050279
     C     AHBRCA        ANDNE     *BLANKS                                                  MD050279
     C     AHBRCA        ANDEQ     #ABRCD(#XB)                                              MD050279
     C     #XB           ANDEQ     1                                                        MD050279
     C                   ADD       1             #XB                                        MD050279
     C     AHBRCA        CHAIN     SDBRCHD0                           60                    MD050279
     C                   ENDIF                                                              MD050279
                                                                                            MD050279
     C     *INL2         IFEQ      *ON                                                      MD050279
     C     AHBRCA        ANDNE     *BLANKS                                                  MD050279
     C     AHBRCA        CHAIN     SDBRCHD0                           60                    MD050279
     C                   ENDIF                                                              MD050279
                                                                                            MD050279
      * If a file is 'skipped', generate reports for skipped files with 'NO DATA'           MD050279
     C     AHBRCA        IFNE      *BLANKS                                                  MD050279
     C     *INL1         ANDEQ     *ON                                                      MD050279
                                                                                            MD050279
     C                   DOW       #AINPT(#XF) <> *BLANKS                                   MD050279
     C                             AND #AINPT(#XF) <> AHINPT                                MD050279
     C                   MOVEL     #AINPT(#XF)   ##INPT                                     MD050279
                                                                                            MD050279
     C     Printf_Open   IFEQ      'Y'                                                      MD050279
     C                   Z-ADD     3             NoOfOutLines                               MD050279
     C                   EXSR      PAGE_CHG_CHK                                             MD050279
     C                   EXCEPT    ENDREPORT                                                MD050279
     C                   CLOSE     GPAUZRPTP1                                               MD050279
     C                   EVAL      PrintF_Open = 'N'                                        MD050279
     C                   ENDIF                                                              MD050279
      *                                                                                     MD050279
     C                   IF        AURename = 'Y'                                           MD050279
     C                   EVAL      qcOvr='OVRPRTF FILE(GPAUZRPTP1) TOFILE(*LIBL'            MD050279
     C                   EVAL      qcOvr=%Trim(qcOvr)+'/GPAUZRPTP1) SPLFNAME('              MD050279
     C                   EVAL      qcOvr=%Trim(qcOvr)+'GPAU'+%Trim(##INPT)+'P1)'            MD050279
     C                   EVAL      qcLen=%Len(%Trim(qcOvr))                                 MD050279
     C                   CALL      'QCMDEXC'                                                MD050279
     C                   PARM                    qcOvr                                      MD050279
     C                   PARM                    qcLen                                      MD050279
     C                   ENDIF                                                              MD050279
      *                                                                                     MD050279
     C     #AINPT(#XF)   CHAIN     GPAUIPD0                           99                    MD050279
     C                   OPEN      GPAUZRPTP1                                               MD050279
     C                   EXSR      SRRCFP1                                                  MD050279
     C                   Z-ADD     99            LineNumber                                 MD050279
     C                   Z-ADD     1             PageNumber                                 MD050279
     C                   EXCEPT    PAGEHEAD                                                 MD050279
     C                   EXCEPT    NODATA                                                   MD050279
     C                   CLOSE     GPAUZRPTP1                                               MD050279
     C                   ADD       1             #XF                                        MD050279
     C                   ENDDO                                                              MD050279
     C                                                                                      MD050279
      **Restore current branch                                                              MD050279
     C**                 MOVEL     SAV_AHBRCA    AHBRCA                                     MD050279
     C                   ADD       1             #XF                                        MD050279
     C                   ENDIF                                                              MD050279
                                                                                            MD050279
      * If input has no branch, remove it from the array                                    MD050279
     C     AHBRCA        IFEQ      *BLANKS                                                  MD050279
     C*                  Z-ADD     1             I                 5 0                      MD050279
     C*    AHINPT        LOOKUP    #AINPT(I)                              99                MD050279
     C*                  EVAL      #AINPT(I) = *BLANKS                                      MD050279
     C*                  SORTA     #AINPT                                                   MD050279
     C                   ENDIF                                                              MD050279
      * Save current branch                                                                 MD050279
     C     AHBRCA        IFNE      *BLANKS                                                  MD050279
     C                   MOVEL     AHBRCA        PREV_BRCA         3                        MD050279
     C                   ENDIF                                                              MD050279
                                                                                            MD050279
     C                   ENDIF                                                              MD053808
                                                                                            MD053808
      * Close then open printer file

     C     Printf_Open   IFEQ      'Y'
     C                   Z-ADD     3             NoOfOutLines
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    ENDREPORT
     C                   CLOSE     GPAUZRPTP1
     C                   ENDIF
      *                                                                                     MD043639
     C                   IF        AURename = 'Y'                                           MD043639
     C                   EVAL      qcOvr='OVRPRTF FILE(GPAUZRPTP1) TOFILE(*LIBL'            MD043639
     C                   EVAL      qcOvr=%Trim(qcOvr)+'/GPAUZRPTP1) SPLFNAME('              MD043639
     C                   EVAL      qcOvr=%Trim(qcOvr)+'GPAU'+%Trim(AHINPT)+'P1)'            MD043639
     C                   EVAL      qcLen=%Len(%Trim(qcOvr))                                 MD043639
     C                   CALL      'QCMDEXC'                                                MD043639
     C                   PARM                    qcOvr                                      MD043639
     C                   PARM                    qcLen                                      MD043639
     C                   ENDIF                                                              MD043639
      *                                                                                     MD043639
     C                   OPEN      GPAUZRPTP1
     C                   EXSR      SRRCFP1
     C                   MOVEL     'Y'           Printf_Open       1
     C                   Z-ADD     99            LineNumber        3 0
     C                   Z-ADD     1             PageNumber        5 0

     C   L2              DO
     C     AHBRCA        IFNE      *BLANK
     C     AHBRCA        CHAIN     SDBRCHD0                           60
     C                   ELSE
     C                   SETON                                        60
     C                   ENDIF
     C                   ENDDO

     C     AHINPT        CHAIN     GPAUIPD0                           99
     C   99              MOVEL     *BLANK        AIDESC
     C   99              MOVEL     ' * UNKNOWN *'AIDESC

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Create reporting date from machine date in YYMMDD format
      ****************************************************************
     C     REPORT_DATE   BEGSR

     C                   MOVEL     AHDATE        YYMMDD
     C                   MOVE      *BLANK        Rept_Date         7
     C                   EVAL      Rept_DATE = %subst(YYMMDD: 5:2)
     C                                      + MON(MM)
     C                                      + %subst(YYMMDD: 1:2)

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Audit Field Attributes - Retrieval
      ****************************************************************
     C     AUFD_RTL      BEGSR

     C                   CALLB     'GPAUFDRTL'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * File
      * Record ID
      * Category (R=report)
     C                   PARM      AHFILE        InFile           10
     C                   PARM      AHRCID        InRecordID       15
     C                   PARM      'R'           InCategory        1
      * OUTPUT
      * Field Attributes
      * Field Shortnames
      * Field Descriptions
     C                   PARM                    #_FDATRB
     C                   PARM                    #_FDSNAM
     C                   PARM                    #_FDFDES
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'BAD FIELDS:'+InFile+InRecordID
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Audit Change Details - Retrieval
      ****************************************************************
     C     AUCD_RTL      BEGSR

     C                   CALLB     'GPAUCDRTL'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * Zone
      * ID
      * Entry Type
     C                   PARM                    I#ZONE           10
     C                   PARM      AHCID         I#CID            17 0
     C                   PARM      AHENTT        I#ENTT            2
      * Field Attributes
      * Field Shortnames
     C                   PARM                    #_FDATRB
     C                   PARM                    #_FDSNAM
      * OUTPUT
      * Field Contents
     C                   PARM                    #_FDCON
     C                   PARM                    #B_FDCON
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'BAD DATA:'+InFile+InRecordID
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
     C****************************************************************
      /SPACE 5
      ****************************************************************
      * Load Report Narrative to Report
      ****************************************************************
     C     LOAD_NARR     BEGSR

     C                   CALLB     'GPAURNLOD'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * File
      * Record ID
     C                   PARM      AHFILE        InFile           10
     C                   PARM      AHRCID        InRecordID       15
      * OUTPUT
      * Total Lines
      * Highest Line
     C                   PARM                    TOT
     C**********         PARM                    HLN               2 0                      MD043639
     C                   PARM                    HLN               3 0                      MD043639
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'BAD NARR:'+InFile+InRecordID
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Load Fields to Report
      *****************************************************************
     C     LOAD_FLDS     BEGSR

     C                   Z-ADD     1             #FD               3 0
     C     #FD           DOWLE     250
     C     #_FDATRB(#FD) ANDNE     *BLANK

     C                   MOVEL     #_FDATRB(#FD) #FDATRB
     C     AFLN          IFNE      0
     C                   MOVE      *BLANK        ArFDCON
     C     Before_After  IFEQ      'A'
     C                   MOVEA     #_FDCON(#FD)  ArFDCON
     C                   ELSE
     C                   MOVEA     #B_FDCON(#FD) ArFDCON
     C                   ENDIF
     C                   EXSR      ADD_FDCON
     C     AHENTT        IFEQ      'PT'
     C     AHENTT        OREQ      'DL'
     C     AHENTT        OREQ      'UP'
     C     AHACTN        ANDNE     'AMEND'
     C     AHENTT        OREQ      'UP'
     C     AHACTN        ANDEQ     'AMEND'
     C     #_FDCON(#FD)  ANDNE     #B_FDCON(#FD)
     C                   EXSR      ADD_FDCON_CHG
     C                   ENDIF
     C                   ENDIF

     C                   ADD       1             #FD

     C                   ENDDO

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Add Field Contents to Report
      ****************************************************************
     C     ADD_FDCON     BEGSR

     C* START POINT

     C                   Z-ADD     AFPS          X                 3 0

     C* GET LINE

     C                   MOVEA     TOT(AFLN)     LIN

     C* END POINT

     C                   Z-ADD     1             Y                 3 0
     C     Y             DOWLE     AFEDTS
     C                   MOVE      ArFDCON(Y)    LIN(X)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   END
     C* UPDATE
     C                   MOVEA     LIN           TOT(AFLN)

     C* HIGHEST LINE?

     C     AFLN          IFGT      HLN
     C                   Z-ADD     AFLN          HLN
     C                   END

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ****************************************************************
      * Add Changed Field Contents to Report
      ****************************************************************
     C     ADD_FDCON_CHG BEGSR

     C* START POINT

     C                   Z-ADD     AFPS          X                 3 0
     C* GET LINE

     C                   MOVEA     TOTC(AFLN)    LIN

     C* HIGHLIGHT CHANGES

     C     AHENTT        IFEQ      'UP'
     C     AHACTN        ANDEQ     'AMEND'
     C                   SUB       1             X
     C                   MOVE      '!'           LIN(X)
     C                   ADD       1             X
     C                   ENDIF

     C* END POINT

     C                   Z-ADD     1             Y                 3 0
     C     Y             DOWLE     AFEDTS
     C                   MOVE      ArFDCON(Y)    LIN(X)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   END
     C* UPDATE
     C                   MOVEA     LIN           TOTC(AFLN)

     C* HIGHEST LINE?

     C     AFLN          IFGT      HLN
     C                   Z-ADD     AFLN          HLN
     C                   END

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Page Change Check
      *****************************************************************
     C     PAGE_CHG_CHK  BEGSR

     C                   ADD       NoOfOutLines  LineNumber
     C     LineNumber    IFGT      60
     C                   EXCEPT    PAGEHEAD
     C                   Z-ADD     2             LineNumber
     C                   ADD       NoOfOutLines  LineNumber
     C                   ADD       1             PageNumber
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ****************************************************************
      * End of report
      ****************************************************************
     C     END_REPT      BEGSR

      * Output '* END OF REPORT *' or '* NO DATA TO REPORT *'

     C     Printf_Open   IFEQ      'Y'
     C                   Z-ADD     3             NoOfOutLines
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    ENDREPORT
                                                                                            MD050279
     C                   CLOSE     GPAUZRPTP1                                               MD050279
                                                                                            MD053808
     C     GenReport     IFEQ      'Y'                                                      MD053808
                                                                                            MD053808
      * and print rest of the report for that branch                                        MD050279
                                                                                            MD050279
     C                   DOW       #AINPT(#XF) <> *BLANKS                                   MD050279
     C                   MOVEL     #AINPT(#XF)   ##INPT                                     MD050279
                                                                                            MD050279
     C                   IF        AURename = 'Y'                                           MD050279
     C                   EVAL      qcOvr='OVRPRTF FILE(GPAUZRPTP1) TOFILE(*LIBL'            MD050279
     C                   EVAL      qcOvr=%Trim(qcOvr)+'/GPAUZRPTP1) SPLFNAME('              MD050279
     C                   EVAL      qcOvr=%Trim(qcOvr)+'GPAU'+%Trim(##INPT)+'P1)'            MD050279
     C                   EVAL      qcLen=%Len(%Trim(qcOvr))                                 MD050279
     C                   CALL      'QCMDEXC'                                                MD050279
     C                   PARM                    qcOvr                                      MD050279
     C                   PARM                    qcLen                                      MD050279
     C                   ENDIF                                                              MD050279
      *                                                                                     MD050279
     C     #AINPT(#XF)   CHAIN     GPAUIPD0                           99                    MD050279
     C                   OPEN      GPAUZRPTP1                                               MD050279
     C                   EXSR      SRRCFP1                                                  MD050279
     C                   Z-ADD     99            LineNumber                                 MD050279
     C                   Z-ADD     1             PageNumber                                 MD050279
     C                   EXCEPT    PAGEHEAD                                                 MD050279
     C                   EXCEPT    NODATA                                                   MD050279
     C                   CLOSE     GPAUZRPTP1                                               MD050279
     C                   ADD       1             #XF                                        MD050279
     C                   ENDDO                                                              MD050279
                                                                                            MD050279
      * and finally print all reports for any branch no reported yet                        MD050279
                                                                                            MD050279
     C     #ABRCD(#XB)   DOWNE     *BLANKS                                                  MD050279
     C     #ABRCD(#XB)   CHAIN     SDBRCHD0                           60                    MD050279
     C                   EVAL      AHBRCA = #ABRCD(#XB)                                     MD050279
      * for new branch reset file pointer                                                   MD050279
     C                   Z-ADD     1             #XF                                        MD050279
                                                                                            MD050279
     C                   DOW       #AINPT(#XF) <> *BLANKS                                   MD050279
     C                   MOVEL     #AINPT(#XF)   ##INPT            4                        MD050279
                                                                                            MD050279
     C                   IF        AURename = 'Y'                                           MD050279
     C                   EVAL      qcOvr='OVRPRTF FILE(GPAUZRPTP1) TOFILE(*LIBL'            MD050279
     C                   EVAL      qcOvr=%Trim(qcOvr)+'/GPAUZRPTP1) SPLFNAME('              MD050279
     C                   EVAL      qcOvr=%Trim(qcOvr)+'GPAU'+%Trim(##INPT)+'P1)'            MD050279
     C                   EVAL      qcLen=%Len(%Trim(qcOvr))                                 MD050279
     C                   CALL      'QCMDEXC'                                                MD050279
     C                   PARM                    qcOvr                                      MD050279
     C                   PARM                    qcLen                                      MD050279
     C                   ENDIF                                                              MD050279
      *                                                                                     MD050279
     C     #AINPT(#XF)   CHAIN     GPAUIPD0                           99                    MD050279
     C                   OPEN      GPAUZRPTP1                                               MD050279
     C                   EXSR      SRRCFP1                                                  MD050279
     C                   Z-ADD     99            LineNumber                                 MD050279
     C                   Z-ADD     1             PageNumber                                 MD050279
     C                   EXCEPT    PAGEHEAD                                                 MD050279
     C                   EXCEPT    NODATA                                                   MD050279
     C                   CLOSE     GPAUZRPTP1                                               MD050279
     C                   ADD       1             #XF                                        MD050279
     C                   ENDDO                                                              MD050279
     C                                                                                      MD050279
     C                   ADD       1             #XB                                        MD050279
     C                   ENDDO                                                              MD050279
                                                                                            MD050279
     C                   ENDIF                                                              MD053808
                                                                                            MD053808
     C                   ELSE
      *                                                                                     MD043639
      * If no details, print all reports for all branches                                   MD050279
                                                                                            MD050279
     C     GenReport     IFEQ      'Y'                                                      MD053808
                                                                                            MD053808
     C     #ABRCD(#XB)   DOWNE     *BLANKS                                                  MD050279
     C     #ABRCD(#XB)   CHAIN     SDBRCHD0                           60                    MD050279
     C                   EVAL      AHBRCA = #ABRCD(#XB)                                     MD050279
      * for new branch reset file pointer                                                   MD050279
     C                   Z-ADD     1             #XF                                        MD050279
                                                                                            MD050279
     C                   DOW       #AINPT(#XF) <> *BLANKS                                   MD050279
     C                   MOVEL     #AINPT(#XF)   AHINPT                                     MD050279
                                                                                            MD050279
     C                   IF        AURename = 'Y'                                           MD043639
     C                   EVAL      qcOvr='OVRPRTF FILE(GPAUZRPTP1) TOFILE(*LIBL'            MD043639
     C                   EVAL      qcOvr=%Trim(qcOvr)+'/GPAUZRPTP1) SPLFNAME('              MD043639
     C                   EVAL      qcOvr=%Trim(qcOvr)+'GPAU'+%Trim(AHINPT)+'P1)'            MD043639
     C                   EVAL      qcLen=%Len(%Trim(qcOvr))                                 MD043639
     C                   CALL      'QCMDEXC'                                                MD043639
     C                   PARM                    qcOvr                                      MD043639
     C                   PARM                    qcLen                                      MD043639
     C                   ENDIF                                                              MD043639
      *                                                                                     MD043639
     C     #AINPT(#XF)   CHAIN     GPAUIPD0                           99                    MD050279
     C                   OPEN      GPAUZRPTP1                                               MD050279
     C                   EXSR      SRRCFP1                                                  MD050279
     C                   Z-ADD     99            LineNumber                                 MD050279
     C                   Z-ADD     1             PageNumber                                 MD050279
     C                   EXCEPT    PAGEHEAD                                                 MD050279
     C                   EXCEPT    NODATA                                                   MD050279
     C                   CLOSE     GPAUZRPTP1                                               MD050279
     C                   ADD       1             #XF                                        MD050279
     C                   ENDDO                                                              MD050279
     C                                                                                      MD050279
     C                   ADD       1             #XB                                        MD050279
     C                   ENDDO                                                              MD050279
                                                                                            MD050279
     C**********         OPEN      GPAUZRPTP1                                               MD050279
     C**********         EXSR      SRRCFP1                                                  MD050279
     C**********         Z-ADD     3             NoOfOutLines                               MD050279
     C**********         EXSR      PAGE_CHG_CHK                                             MD050279
     C**********         EXCEPT    NODATA                                                   MD050279
                                                                                            MD053808
     C                   ENDIF                                                              MD053808
                                                                                            MD053808
     C                   ENDIF

      * Close printer file
     C**********         CLOSE     GPAUZRPTP1                                               MD050279

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      *****************************************************************
      * SRRCFP1 - Detail Spool File recorded by RCF
      *****************************************************************
     C     SRRCFP1       BEGSR

     C                   EVAL      ZSnum = PSFNum1

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      AHBRCA        PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr

      ** If Error occurs during ZSFILE processing, then end abnormally

     C                   IF        ZSErr = 'Y'
     C                   EVAL      I#ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUT
      * Zone
     C                   PARM                    I#ZONE           10
      * Sequence
     C                   PARM                    PSeq

     C* GET BANK DETAILS

     C     I#ZONE        CHAIN     SDBANKD0                           99        *

     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'BAD ZONE:' + I#ZONE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Z-ADD     99            LineNumber        3 0
     C                   Z-ADD     1             PageNumber        5 0

      ** Retrieve System Value                                                              MD043639
     C                   CALL      'GPAOSVALR0'                                             MD043639
     C                   PARM      *BLANKS       PRtcd                                      MD043639
     C                   PARM      SysVal1       PSValK1                                    MD043639
     C                   PARM                    PSVal1                                     MD043639
     C                   PARM      *BLANKS       PSValK2                                    MD043639
     C                   PARM                    PSVal2                                     MD043639
     C                   PARM      *BLANKS       PSValK3                                    MD043639
     C                   PARM                    PSVal3                                     MD043639
     C                   PARM      *BLANKS       PSValK4                                    MD043639
     C                   PARM                    PSVal4                                     MD043639
     C                   PARM      *BLANKS       PSValK5                                    MD043639
     C                   PARM                    PSVal5                                     MD043639
     C                   PARM      *BLANKS       PSValK6                                    MD043639
     C                   PARM                    PSVal6                                     MD043639
     C                   PARM      *BLANKS       PSValK7                                    MD043639
     C                   PARM                    PSVal7                                     MD043639
     C                   PARM      *BLANKS       PSValK8                                    MD043639
     C                   PARM                    PSVal8                                     MD043639
     C                   PARM      *BLANKS       PSValK9                                    MD043639
     C                   PARM                    PSVal9                                     MD043639
     C                   PARM      *BLANKS       PSValK10                                   MD043639
     C                   PARM                    PSVal10                                    MD043639
      *                                                                                     MD043639
     C                   IF        Prtcd = *BLANKS                                          MD043639
     C                   MOVEL     PSVal1        AURename          1                        MD043639
     C                   ENDIF                                                              MD043639
      *                                                                                     MD053808
      ** Call Access Program for System Value - 'GenAuRptNoDtaChg'                          MD053808
      *                                                                                     MD053808
     C                   CALL      'AOSVALR0'                                               MD053808
     C                   PARM      *BLANKS       PRtcd@                                     MD053808
     C                   PARM      SysVal@       P@OP01                                     MD053808
     C                   PARM                    P@VL01                                     MD053808
     C                   PARM      *BLANKS       P@OP02                                     MD053808
     C                   PARM                    P@VL02                                     MD053808
     C                   PARM      *BLANKS       P@OP03                                     MD053808
     C                   PARM                    P@VL03                                     MD053808
     C                   PARM      *BLANKS       P@OP04                                     MD053808
     C                   PARM                    P@VL04                                     MD053808
     C                   PARM      *BLANKS       P@OP05                                     MD053808
     C                   PARM                    P@VL05                                     MD053808
     C                   PARM      *BLANKS       P@OP06                                     MD053808
     C                   PARM                    P@VL06                                     MD053808
     C                   PARM      *BLANKS       P@OP07                                     MD053808
     C                   PARM                    P@VL07                                     MD053808
     C                   PARM      *BLANKS       P@OP08                                     MD053808
     C                   PARM                    P@VL08                                     MD053808
     C                   PARM      *BLANKS       P@OP09                                     MD053808
     C                   PARM                    P@VL09                                     MD053808
     C                   PARM      *BLANKS       P@OP10                                     MD053808
     C                   PARM                    P@VL10                                     MD053808
      *                                                                                     MD053808
     C                   IF        PRtcd@ = *BLANKS                                         MD053808
     C                   MOVEL     P@VL01        GenReport         1                        MD053808
     C                   ENDIF                                                              MD053808
                                                                                            MD053808

      * Load all Audit Files                                                                MD050279
     C                   Z-ADD     0             #XF               5 0                      MD050279
     C     *LOVAL        SETLL     GPAUIPPD                                                 MD050279
     C                   READ      GPAUIPPD                                                 MD050279
     C                   DOW       NOT %EOF(GPAUIPPD)                                       MD050279
     C                   ADD       1             #XF                                        MD050279
     C                   MOVEL     AIINPT        #AINPT(#XF)                                MD050279
     C                   READ      GPAUIPPD                                                 MD050279
     C                   ENDDO                                                              MD050279
      * Initialize pointer                                                                  MD050279
     C                   Z-ADD     1             #XF                                        MD050279
                                                                                            MD050279
      * Load all Brnaches                                                                   MD050279
     C                   Z-ADD     0             #XB               5 0                      MD050279
     C     *LOVAL        SETLL     GZSDBRCHL0                                               MD050279
     C                   READ      GZSDBRCHL0                                               MD050279
     C                   DOW       NOT %EOF(GZSDBRCHL0)                                     MD050279
     C     I#ZONE        IFEQ      A8ZONE                                                   MD050279
     C                   ADD       1             #XB                                        MD050279
     C                   MOVEL     A8BRCD        #ABRCD(#XB)                                MD050279
     C                   ENDIF                                                              MD050279
     C                   READ      GZSDBRCHL0                                               MD050279
     C                   ENDDO                                                              MD050279
      * Initialize pointer                                                                  MD050279
     C                   Z-ADD     1             #XB                                        MD050279
                                                                                            MD050279
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
     OGPAUZRPTP1E            PAGEHEAD          1
1436 O                                           20 'REFERENCE GPAUZRPT'
1437 O                       BJURPT              89
1438 O                                          104 'DATE'
1439 O                       BJMRDT             112
1440 O                                          122 'PAGE'
1441 O                       PageNumber    Z    127
     O          E            PAGEHEAD    1
     O                                           65 'A U D I T  R E P O R T - '
     O                       AIDESC             105
     O              N60      AHBRCA             101
     O              N60                         102 '-'
     O              N60      A8BRNM             132
     O          E            CHANGEID    2
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O                                          132 '=='
     O          E            CHANGEID    1
     O                                            7 'Action:'
     O                       AHACTN              17
     O                                           21 'ID:'
     O                       R_REFI              74
     O                                           80 'User:'
     O                       AHUSER              90
     O                                           96 'Date:'
     O                       REPT_DATE          103
     O                                          109 'Time:'
     O                       AHTIME             117 '  :  :  '
     O                                          122 'TRN:'
     O                       AHCCID        Z    132
     O          E            CHANGEID    1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O                                          132 '=='
     O          E            AFTERNARR   1
     O                                           26 'A F T E R   I M A G E ----'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          132 '>>'
     O          E            BEFORENARR  1
     O                                           26 'B E F O R E   I M A G E---'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          132 '>>'
     O          E            REPORTLINE  1
     O                       TOT(OLN)           132
     O          E            REPORTLINC  0
     O                       TOTC(OLN)          132
     O          E            ENDREPORT   3
     O                                           65 '* END OF REPORT *'
     O          E            NODATA      3
     O                                           65 '* NO DATA TO REPORT *'
** MON
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
