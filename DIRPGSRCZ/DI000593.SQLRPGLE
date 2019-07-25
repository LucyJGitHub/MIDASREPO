     H DEBUG
     H***DFTACTGRP(*NO)                                                                     MD023629
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*S*D ***RPGSQLBND*****************************************************                     MD023629
/*STD *  RPGSQLMOD                                                    *                     MD023629
/*EXI *  TEXT('Midas OF Accounting Rules Process for Nostro Recon')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GL000593*-*Midas*OF*Accounting*Rules*Process*for**************                     MD029739
      *  DI000593 - Midas OF Accounting Rules Process for             *                     MD029739
      *             Nostro Reconciliation                             *
      *                                                               *
      *  Function:  This program displays Nostro Reconciliation       *
      *                 Monitor                                       *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD035766           Date 25May16               *
      *                 MD029739 *RENAMED* Date 15Aug14               *
      *                 MD029683           Date 19Aug14               *
      *                 MD023629           Date 22Nov13               *
      *                 CGL135A *CREATE    Date 08Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035766 - Monitor Nostro Reconciliation Process screen is   *
      *             showing wrong Account ID for some Nostro accounts *
      *  MD029739 - File renaming for integration layer.              *
      *  MD029683 - Nostro Accounts Reconciliation Monitor            *
      *             Enhancement.                                      *
      *  MD023629 - Accounting Rules Processing                       *
      *  CGL135A - Accounting Rules Processing                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    27         Rollup/Rolldown Key                             *
      *    32         Currency Indicator                              *
      *    33         A/C Branch Indicator                            *
      *    34         Not Initiated Today Indicator                   *
      *    40         Global Error Indicator                          *
      *    78         '?' Indicator                                   *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Subfile End (SFLEND)                            *
      *****83****     Force Input Format                              *                     MD023629
      *    84         Subfile Next Change (SFLNXTCHG)                 *
      *****86****     PUTOVR Indicator                                *                     MD023629
      *****87****     Enable Key Screen                               *                     MD023629
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRBuild       -  Initialise and load subfile page            *
      *  SRLoad        -  Load subfile page                           *
      *  SRDisplay     -  Display subfile                             *
      *  SRProcess     -  Process screen input                        *
      ***SRMode****    -  Switch between *ADD and *CHANGE modes       *                     MD023629
      *  SRReload      -  Request subfile reload                      *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Transfer records from SDFCSDL0 to subfile   *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Forecast Static Data Display File
     F***GL000593DFCFE             WORKSTN USROPN                                           MD029739
     FDI000593DFCF   E             WORKSTN USROPN                                           MD029739
     F                                     SFILE(GL000593S1:SRLRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

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

     D*RECONSTAT***    S             25    DIM(9) CTDATA PERRCD(1)                          MD023629
     D*RECONDESC***    S             50    DIM(9) CTDATA PERRCD(1)                          MD023629
     D*RECONSTAT***    S             25    DIM(12) CTDATA PERRCD(1)                MD023629 MD029683
     D*RECONDESC***    S             50    DIM(12) CTDATA PERRCD(1)                MD023629 MD029683
     D RECONSTAT       S             25    DIM(13) CTDATA PERRCD(1)                         MD029683
     D RECONDESC       S             50    DIM(13) CTDATA PERRCD(1)                         MD029683

      ** Review from fields                                                                 MD023629
     D                 DS                                                                   MD023629
     D**SPOSN***               1      5                                                     MD023629
     D**SPOSN***               1     39                                            MD023629 MD029683
     D  SPOSN                  1    110                                                     MD029683
     D**#1POS1***              1      3                                            MD023629 MD029683
     D  #1POS1                 1      5                                                     MD029683
     D**#1POS2***              4     33                                            MD023629 MD029683
     D  #1POS2                 6     35                                                     MD029683
     D**#1POS3***             34     35                                            MD023629 MD029683
     D  #1POS4                36     38                                                     MD023629
     D  #1POS5                39     39                                                     MD023629
     D  #1POS6                40     94                                                     MD029683
     D  #1POS7                95    100                                                     MD029683
     D  #1POS8               101    110                                                     MD029683

      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)

      ***Rundate*data*area                                                                  MD023629
     D*RUNDAT***       DS                                                                   MD023629
     D**WSUC****              11     11                                                     MD023629
     D**WMBIN***              13     13                                                     MD023629

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** External DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A_)

      ** External DS for Customer Details                                                   MD029683
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                MD029683
                                                                                            MD029683
     D                 DS
     D  WTIME                  1      6
     D  WHR                    1      2
     D  WMIN                   3      4
     D  WSEC                   5      6

     D*ARNR*****     E DS                  EXTNAME(GLARNRTD)                                MD029739
     D ARNR          E DS                  EXTNAME(DIARNRTD)                                MD029739
     D                                     PREFIX(B_)

      ** File DS - Midas OF Meridian Intellimatch RAW Data                                  MD023629
     D*DSACMETD*     E DS                  EXTNAME(IGACMETD)                       MD023629 MD029739
     D DSACMETD      E DS                  EXTNAME(DIACMETD)                                MD029739
      *                                                                                     MD023629
      ** File DS - Midas GL MT9xx Messages                                                  MD023629
     D DSMR94PD      E DS                  EXTNAME(GLMR94PD)                                MD023629
     D   QQACCD1     E                     EXTFLD(QQACCD)                                   MD023629
      *                                                                                     MD023629
      ** Data structure to retrieve Batch Id                                                MD023629
      *                                                                                     MD023629
     D SELDAT          DS             6                                                     MD023629
     D  SELDA                  1      2                                         Day         MD023629
     D  SELMM                  3      4                                         Month       MD023629
     D  SELYY                  5      6                                         Year        MD023629
      *                                                                                     MD023629
     D SELFLD          DS             8                                                     MD023629
     D  SELIM                  1      2    INZ('IM')                            'IM'        MD023629
     D  SELDY                  3      4                                         Year        MD023629
     D  SELDM                  5      6                                         Month       MD023629
     D  SELDD                  7      8                                         Day         MD023629
      *                                                                                     MD023629
      ** Data structure to redefine timestamp                                               MD023629
      *                                                                                     MD023629
     D ExtTmsTmp       DS            26                                                     MD023629
     D  ExtYY                  1      4                                         Year        MD023629
     D  ExtS1                  5      5                                         '-'         MD023629
     D  ExtMM                  6      7                                         Month       MD023629
     D  ExtS2                  8      8                                         '-'         MD023629
     D  ExtDD                  9     10                                         Day         MD023629
     D  ExtS3                 11     11                                         'T'         MD023629
     D  ExtHH                 12     13S 0                                      Hour        MD023629
     D  ExtS4                 14     14                                         ':'         MD023629
     D  ExtMN                 15     16S 0                                      Minutes     MD023629
     D  ExtS5                 17     17                                         ':'         MD023629
     D  ExtSC                 18     19S 0                                      Second      MD023629
     D  ExtS6                 20     20                                         '.'         MD023629
     D  ExtNS                 21     23                                         Nano sec    MD023629
     D  ExtFl                 24     26                                         Filler      MD023629
      *                                                                                     MD023629
      ** Data structure for ZDATE10                                                         MD023629
      *                                                                                     MD023629
     D                 DS                                                                   MD023629
     D  ZZDTIN                 1      8  0                                                  MD023629
     D  ZWYYYY                 1      4  0                                                  MD023629
     D  ZWMTH                  5      6  0                                                  MD023629
     D  ZWDAY                  7      8  0                                                  MD023629
      *                                                                                     MD023629
     D pSQL_RanOk      PR              N
     D  iSQLState                     5A   Const


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D UP              C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D LO              C                   CONST('abcdefghijklmnopqrstuvwxyz')
     D

     D @RUN            S              1
     D*CAIN89***       S              1                                                     MD023629
     D CPY2@           S             80

      ** Database error workfields
     D PRTCD           S              7
     D POPTN           S              7

      ** Message file workfields - Parameters list for ZA0340 / ZA0350
     D PZMsgFile       S             10A   INZ(' ')
     D PZMsgID         S             10
     D PZMsgDta        S             45A

      ** General workfields
     D*CAIN81***       S              1                                                     MD023629
     D PMODE           S              1
     D*WKIPIN***       S              1                                                     MD023629
     D WLRCD           S              4  0
     D*WPOSN****       S              5                                                     MD023629
     D WPOSN           S                   LIKE(SPOSN)                                      MD023629
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D*W1PMD****       S              3                                                     MD023629
     D W1RSF           S              1

      ** Subfile workfields
     D WSkipRec        S              1

      ** Parameter list fields for ZDATE2
     D PzDayNo         S              5  0
     D PBJDFIN         S              1
     D PzDate          S              6  0
     D PZADate         S              7

      ** Parameters for GLC000597                                                           MD023629
     D PPARM100        S            100                                                     MD023629
      *                                                                                     MD023629
      ** Parameters for GLC000599                                                           MD023629
     D PBTID           S             60                                         Batch ID    MD023629
     D PTMST           S             26                                         Time Stamp  MD023629
      *                                                                                     MD023629
      ** Parameters for ZDATE10                                                             MD023629
     D DateIn          S                   LIKE(ZZDTIN)                                     MD023629
     D DaynoOut        S              5P 0                                                  MD023629
      *                                                                                     MD023629
      ** Parameters for ZAMSGRTVMS                                                          MD023629
     D CompMsg         S           3000                                                     MD023629
     D Level           S              1                                                     MD023629
      *                                                                                     MD023629
      ** System Values details                                                              MD023629
     D PSysVal1        C                   CONST('AcctRulesRealTimPost')                    MD023629
     D PSysVal2        C                   CONST('ProduceMT940')                            MD023629
     D PSysVal3        C                   CONST('AcctRulesAutoAuth')                       MD023629
      *                                                                                     MD023629
      ** Parameter variables for AOSVALR0 string                                            MD023629
     D SVALK1          S             20                                                     MD023629
     D SVAL1           S            200                                                     MD023629
     D SVALK2          S             20                                                     MD023629
     D SVAL2           S            200                                                     MD023629
     D SVALK3          S             20                                                     MD023629
     D SVAL3           S            200                                                     MD023629
     D SVALK4          S             20                                                     MD023629
     D SVAL4           S            200                                                     MD023629
     D SVALK5          S             20                                                     MD023629
     D SVAL5           S            200                                                     MD023629
     D SVALK6          S             20                                                     MD023629
     D SVAL6           S            200                                                     MD023629
     D SVALK7          S             20                                                     MD023629
     D SVAL7           S            200                                                     MD023629
     D SVALK8          S             20                                                     MD023629
     D SVAL8           S            200                                                     MD023629
     D SVALK9          S             20                                                     MD023629
     D SVAL9           S            200                                                     MD023629
     D SVALK0          S             20                                                     MD023629
     D SVAL10          S            200                                                     MD023629
      *                                                                                     MD023629
     D K_SELFLD        S              8                                         IM+Date     MD023629
     D K_SELFL2        S             35                                         Our Nostro  MD023629
     D WRTPF           S              1                                         Real Time   MD023629
     D WMT94F          S              1                                         MT940       MD023629
     D WACAAF          S              1                                         Auto-Author.MD023629
      *                                                                                     MD023629
     D MachineTime     S               D                                                    MD029683
     D WMachineTime    S             26A                                                    MD029683
     D WCSNAME         S              6                                                     MD029683
     D POSX            S              2  0                                                  MD029683
     D DateToday       S              5  0                                                  MD029683
     D WHBTCH          S              3                                                     MD029683
     D WACOD           S             10                                                     MD029683
     D WACSQ           S              2                                                     MD029683
     D WFACID          S             55                                                     MD029683
     D WTimeStamp      S             26A                                                    MD023629
     D WStat           S              1                                                     MD023629
     D WScreen         S              1                                                     MD023629

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

      ** Main Program

     C                   DO        *HIVAL

      ** Initialise and load subfile page

     C                   EXSR      SRBuild

     C                   EVAL      W1RSF = 'N'

      ** Display screen until reload requested

     C                   DOW       W1RSF = 'N'

      ** Display screen

     C                   EVAL      WScreen = '1'                                            MD023629
      *                                                                                     MD023629
     C                   EXSR      SRDisplay

      ** Process response

     C     *IN03         CASEQ     *ON           SREnd

     C     *IN05         CASEQ     *ON           SRReload

     C     SPOSN         CASNE     WPOSN         SRReload                                   MD023629

     C     *IN27         CASEQ     *ON           SRLoad

     C***********        CAS                     SRProcess                                  MD023629
     C     *IN81         CASEQ     *ON           SRProcess                                  MD023629
     C                   ENDCS

     C                   IF        *IN03 = *ON
     C                   EXSR      SREnd
     C                   ENDIF

     C                   ENDDO

     C                   ENDDO
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      *****************************************************************
     C     SRBuild       BEGSR

      ** Initialise & load subfile page

     C                   EVAL      *IN80 = *ON
     C                   WRITE     GL000593C1
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF

      ** Reset Number of Records in Subfile

     C                   Z-ADD     0             WLRCD
     C                   Z-ADD     0             SRLRN                                      MD023629

      ** If CHANGE mode, then position file

     C                   EVAL      *IN82 = *OFF

     C**********         IF        W1PMD <> 'ADD'                                           MD023629
     C**********         EVAL      WPOSN = SPOSN                                            MD023629

      ** Setup key

     C/exec SQL
     C+ close NostroRecon
     C/end-exec

     C/exec sql
     C+ open NostroRecon
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from NostroRecon
     C+ into : ARNR
     C/end-exec

     C**********         ELSE                                                               MD023629
     C**********         EVAL      *IN82 = *OFF                                             MD023629
     C**********         ENDIF                                                              MD023629

     C                   If        %Subst(SQLState:1:2) = '02'
     C                   EVAL      *IN82 = *ON
     C                   ENDIF

      ** Control selection fields                                                           MD023629
      *                                                                                     MD023629
      ***Currency***                                                               MD023629 MD029683
      **********                                                                   MD023629 MD029683
     C*****'?'           SCAN      #1POS1                                 78       MD023629 MD029683
     C**********         IF        *IN78 = *ON                                     MD023629 MD029683
     C**********         CALL      'SD0020S'                       Select Currency MD023629 MD029683
     C**********         PARM      *BLANK        W0RTN             7               MD023629 MD029683
     C*****#1POS1        PARM      *BLANK        WQ0003            3 Currency Code MD023629 MD029683
     C**********         ENDIF                                                     MD023629 MD029683
      *                                                                                     MD023629
      ** Status                                                                             MD023629
      *                                                                                     MD023629
     C     '?'           SCAN      #1POS2                                 78                MD023629
     C                   IF        *IN78 = *ON                                              MD023629
     C                   CALL      'Y2VLLSR'                                                MD023629
     C                   PARM      *Blanks       W0RTN                                      MD023629
     C                   PARM      1215013       @Y2LS             7 0                      MD023629
     C                   PARM      *BLANKS       @INVL            25                        MD023629
     C                   EVAL      #1POS2 = *BLANKS                                         MD023629
     C                   IF        W0RTN <> 'Y2U0016'                                       MD023629
     C                   MOVE      0             X                 2 0                      MD023629
     C                   EVAL      X = %LOOKUP(%TRIM(@INVL):RECONSTAT)                      MD023629
     C                   IF        X > 0                                                    MD023629
     C                   EVAL      #1POS2 = %Trim(%Xlate(LO:UP:RECONDESC(X)))               MD023629
     C                   ENDIF                                                              MD023629
     C                   ENDIF                                                              MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
      ** A/C Branch                                                                         MD023629
      *                                                                                     MD023629
     C     '?'           SCAN      #1POS4                                 78                MD023629
     C                   IF        *IN78 = *ON                                              MD023629
     C                   CALL      'SD0061S'                                Select Branch CoMD023629
     C                   PARM      *BLANK        W0RTN                                      MD023629
     C     #1POS4        PARM      *BLANK        WQ0003            3                        MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
      ****Not*Initiated*Today***                                                   MD023629 MD029683
      *** Exported Today                                                                    MD029683
      *                                                                                     MD023629
     C                   IF        #1POS5 <> 'Y' AND #1POS5 <> 'N'                          MD023629
     C                             AND #1POS5 <> *BLANKS                                    MD023629
     C                   EVAL      *IN34 = *ON                                              MD023629
     C                   EVAL      PZMsgFile = 'SDUSRMSG'                                   MD023629
     C                   EVAL      PZMsgID = 'USR0805'                                      MD023629
     C                   EXSR      SRZasnms                                                 MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
      ** Save previous selector values

     C******LIKE         DEFINE    #1POS1        WZCCY                                      MD023629
     C**********         EVAL      WZCCY = #1POS1                                           MD023629
     C******LIKE         DEFINE    #1POS2        WZSTS                                      MD023629
     C**********         EVAL      WZSTS = #1POS2                                           MD023629
     C******LIKE         DEFINE    #1POS3        WZNCD                                      MD023629
     C**********         EVAL      WZNCD = #1POS3                                           MD023629
     C******LIKE         DEFINE    #1POS4        WZBRC                                      MD023629
     C**********         EVAL      WZBRC = #1POS4                                           MD023629
     C******LIKE         DEFINE    #1POS5        WNITD                                      MD023629
     C**********         EVAL      WNITD = #1POS5                                           MD023629
      *                                                                                     MD023629
      ** Bank                                                                               MD029683
      *                                                                                     MD029683
     C     '?'           SCAN      #1POS7                                 78                MD029683
     C                   IF        *IN78 = *ON                                              MD029683
     C                   CALL      'SD0010S'                                                MD029683
     C                   PARM      *BLANK        W0RTN             7                        MD029683
     C     #1POS7        PARM      *BLANK        WQ0004            6                        MD029683
     C                   ENDIF                                                              MD029683
      *                                                                                     MD029683
      ** Bank Shortname                                                                     MD029683
      *                                                                                     MD029683
     C     '?'           SCAN      #1POS8                                 78                MD029683
     C                   MOVE      *BLANKS       WCSNAME                                    MD029683
     C                   IF        *IN78 = *ON                                              MD029683
     C                   CALL      'SD0011S'                                                MD029683
     C                   PARM      *BLANK        W0RTN                                      MD029683
     C     WCSNAME       PARM      *BLANK        WQ0005            6                        MD029683
                                                                                            MD029683
     C/exec SQL                                                                             MD029683
     C+ select *                                                                            MD029683
     C+ into :SDCUST                                                                        MD029683
     C+ from SDCUSTPD                                                                       MD029683
     C+ where BBCUST = :WCSNAME                                                             MD029683
     C/end-exec                                                                             MD029683
                                                                                            MD029683
     C     SQLCOD        IFEQ      *Zeros                                                   MD029683
     C                   EVAL      #1POS8 = BBCSSN                                          MD029683
     C                   ENDIF                                                              MD029683
                                                                                            MD029683
     C                   ENDIF                                                              MD029683
                                                                                            MD029683
     C                   EVAL      WPOSN = SPOSN                                            MD023629

      ** Load subfile page

     C                   EXSR      SRLoad

      ** If no records found, display error message

     C                   IF        %Subst(SQLState:1:2) = '02' AND SRLRN = 0
     C***********        EVAL      PZMsgFile = 'GBSDUSRMSG'                                 MD023629
     C                   EVAL      PZMsgFile = 'SDUSRMSG'                                   MD023629
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      *****************************************************************
     C     SRLoad        BEGSR

      ** Load subfile page but write empty page if add mode

     C                   EVAL      *IN84 = *OFF
     C                   EVAL      W0RTN = *Blanks

      ** Re-establish fields in read-ahead record

     C**********         IF        W1PMD <> 'ADD' and *IN27 = *ON                           MD023629
     C                   IF        *IN27 = *ON                                              MD023629
     C                   IF        pSQL_RanOk(SQLSTATE)

     C/exec SQL
     C**********+ fetch prior                                                               MD029683
     C+ fetch current                                                                       MD029683
     C+ from NostroRecon
     C+ into : ARNR
     C/end-exec

     C**********/exec SQL                                                                   MD029683
     C**********+ fetch next                                                                MD029683
     C**********+ from NostroRecon                                                          MD029683
     C**********+ into : ARNR                                                               MD029683
     C**********/end-exec                                                                   MD029683

     C                   ENDIF
     C                   ENDIF

      ** Start at previous highest record in SFL

     C                   Z-ADD     WLRCD         SRLRN
     C                   Z-ADD     1             WRCTR

      ** Load next subfile page

     C                   DOW       %Subst(SQLState:1:2) <> '02'
     C                             and WRCTR <= WSFPG

     C                   EVAL      WSkipRec = 'N'
     C**********         ADD       1             SRLRN                                      MD023629
      *                                                                                     MD023629
      ** Retrieve detail from holding file                                                  MD023629
      *                                                                                     MD023629
     C                   EVAL      WTimeStamp = *Blanks                                     MD023629
     C                   EXSR      SRACME                                                   MD023629

      ***Protect*fields during Enquiry Mode                                                 MD023629

      ** Start Mode
     C**********         IF        (W1PMD <> 'ADD')                                         MD023629

      ** Status                                                                             MD029683
     C**********         MOVE      *Blanks       WPOS2            22                        MD029683
     C                   MOVE      *Blanks       WPOS2            30                        MD029683
     C                   MOVE      0             POS               2 0
     C                   EVAL      WPOS2 = %Trim(%Xlate(LO:UP:B_ARNRSTS))
                                                                                            MD029683
      ** Account ID (Tag 25)                                                                MD029683
     C                   MOVE      *Blanks       WPOS6            55                        MD029683
     C                   MOVE      0             POSX                                       MD029683
     C                   EVAL      WPOS6 = %Trim(%Xlate(LO:UP:WFACID))                      MD029683
                                                                                            MD029683
     C**********         EVAL      *IN32 = *OFF                                             MD023629
     C**********         EVAL      *IN33 = *OFF                                             MD023629
     C**********         EVAL      *IN34 = *OFF                                             MD023629
     C**********         MOVE      'N'           INVALID           1                        MD023629

      ** Bank and Bank Shortname                                                            MD029683
     C                   IF        (#1POS7 <> *BLANK                                        MD029683
     C                             AND WSkipRec = 'N')                                      MD029683
     C                             Or (#1POS8 <> *BLANK                                     MD029683
     C                             AND WSkipRec = 'N')                                      MD029683
                                                                                            MD029683
     C                   CALL      'AONOSTR0'                                               MD029683
     C                   PARM      *BLANKS       @RTCD                                      MD029683
     C                   PARM      '*KEY   '     @OPTN                                      MD029683
     C                   PARM      *BLANKS       @CNUM                                      MD029683
     C                   PARM      B_ARNRCCY     @CCYD                                      MD029683
     C                   PARM      *BLANKS       @ACOD                                      MD029683
     C                   PARM      *BLANKS       @ASEQ                                      MD029683
     C                   PARM      B_ARNRNCD     @NOST                                      MD029683
     C                   PARM      *BLANKS       @BRCA                                      MD029683
     C                   PARM      *BLANKS       @CSSN                                      MD029683
     C                   PARM      *BLANKS       @PNOI                                      MD029683
     C     SDNOST        PARM      SDNOST        DSSDY                                      MD029683
                                                                                            MD029683
      ** Bank                                                                               MD029683
     C                   IF        #1POS7 <> *BLANK                                         MD029683
     C                   IF        @RTCD <> *BLANKS OR A7CUST <> #1POS7                     MD029683
     C                   EVAL      WSkipRec = 'Y'                                           MD029683
     C                   ENDIF                                                              MD029683
     C                   ENDIF                                                              MD029683
                                                                                            MD029683
      ** Bank Shortname                                                                     MD029683
     C                   IF        #1POS8 <> *BLANK AND                                     MD029683
     C                             @RTCD = *BLANKS                                          MD029683
     C/exec SQL                                                                             MD029683
     C+ select *                                                                            MD029683
     C+ into :SDCUST                                                                        MD029683
     C+ from SDCUSTPD                                                                       MD029683
     C+ where BBCUST = :A7CUST                                                              MD029683
     C/end-exec                                                                             MD029683
                                                                                            MD029683
     C     SQLCOD        IFEQ      *Zeros                                                   MD029683
     C                   IF        #1POS8 <> BBCSSN                                         MD029683
     C                   EVAL      WSkipRec = 'Y'                                           MD029683
     C                   ENDIF                                                              MD029683
     C                   ENDIF                                                              MD029683
                                                                                            MD029683
     C                   ELSEIF    #1POS8 <> *BLANK AND                                     MD029683
     C                             @RTCD <> *BLANKS                                         MD029683
     C                   EVAL      WSkipRec = 'Y'                                           MD029683
     C                   ENDIF                                                              MD029683
                                                                                            MD029683
     C                   ENDIF                                                              MD029683
                                                                                            MD029683
      ** Account ID (Tag 25)                                                                MD029683
     C                   IF        #1POS6 <> *BLANK AND WPOS6 <> #1POS6                     MD029683
     C                             AND WSkipRec = 'N'                                       MD029683
     C                   EVAL      POSX = %Scan(%Trim(#1POS6):WPOS6)                        MD029683
     C                   IF        POSX = 0                                                 MD029683
     C                   EVAL      WSkipRec = 'Y'                                           MD029683
     C                   ENDIF                                                              MD029683
     C                   ENDIF                                                              MD029683
                                                                                            MD029683
      ***Not*Initiated*Today***                                                             MD029683
      ** Exported Today                                                                     MD029683
     C                   IF        #1POS5 <> *BLANK
     C                             AND WSkipRec = 'N'
     C                                                                                      MD029683
     C                   TIME                    MachineTime                                MD029683
     C                   MOVE      *BLANKS       DateToday                                  MD029683
     C                   MOVEL     MachineTime   WMachineTime                               MD029683
     C                   MOVEL     WMachineTime  ExtTmsTmp                                  MD029683
     C                   MOVE      ExtYY         ZWYYYY                                     MD029683
     C                   MOVE      ExtMM         ZWMTH                                      MD029683
     C                   MOVE      ExtDD         ZWDAY                                      MD029683
     C                   CALL      'ZDATE10'                                                MD029683
     C                   PARM      ZZDTIN        DateIn                                     MD029683
     C                   PARM      *ZEROS        DaynoOut                                   MD029683
     C                   MOVE      DaynoOut      DateToday                                  MD029683

     C                   IF        #1POS5 = 'Y' And
     C**********                   B_ARNRDAT >= BJRDNB                                      MD029683
     C                             B_ARNRDAT <> DateToday                                   MD029683
     C                   EVAL      WSkipRec = 'Y'

     C                   ELSEIF    #1POS5 = 'N' And                                         MD029683
     C                             B_ARNRDAT >= DateToday                                   MD029683
     C                   EVAL      WSkipRec = 'Y'                                           MD029683

     C                   ELSEIF    #1POS5 <> 'Y' AND #1POS5 <> 'N'                          MD023629
     C**********                   AND #1POS5 <> *BLANKS                                    MD023629
     C**********         MOVE      'Y'           INVALID                                    MD023629
     C                   EVAL      WSkipRec = 'Y'                                           MD023629
     C                   ENDIF

     C                   ENDIF

      ** A/C Branch
     C**********         IF        #1POS4 <> *BLANK                                         MD023629
      ***Name*search required?                                                              MD023629
     C*****'?'**         SCAN      #1POS4                                 78                MD023629
     C**********         IF        *IN78 = *ON AND W0RTN <> 'Y2U0016'                       MD023629
     C**********         CALL      'SD0061S'                                Select Branch CoMD023629
     C**********         PARM      *BLANK        W0RTN                                      MD023629
     C*****#1POS4        PARM      *BLANK        WQ0003                                     MD023629
     C**********         ENDIF                                                              MD023629

     C                   IF        #1POS4 <> *BLANK
     C                             AND WSkipRec = 'N'

     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CNUM
     C                   PARM      B_ARNRCCY     @CCYD
     C                   PARM      *BLANKS       @ACOD
     C                   PARM      *BLANKS       @ASEQ
     C                   PARM      B_ARNRNCD     @NOST
     C                   PARM      *BLANKS       @BRCA
     C                   PARM      *BLANKS       @CSSN
     C                   PARM      *BLANKS       @PNOI
     C     SDNOST        PARM      SDNOST        DSSDY

     C                   IF        @RTCD <> *BLANKS OR A7BRCD <> #1POS4
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF

     C                   ENDIF
     C**********         ENDIF                                                              MD023629

      ***Nostro*Code***                                                                     MD029683
     C**********         IF        #1POS3 <> *BLANK  AND  B_ARNRNCD <> #1POS3               MD029683
     C**********                   AND WSkipRec = 'N'                                       MD029683
     C**********         EVAL      WSkipRec = 'Y'                                           MD029683
     C**********         ENDIF                                                              MD029683

      ** Status
     C**********         IF        #1POS2 <> *BLANK                                         MD023629
      **********                                                                            MD023629
     C*****'?'**         SCAN      #1POS2                                 78                MD023629
     C**********         IF        *IN78 = *ON AND W0RTN <> 'Y2U0016'                       MD023629
     C**********         CALL      'Y2VLLSR'                                                MD023629
     C**********         PARM      *Blanks       W0RTN                                      MD023629
     C**********         PARM      1215013       @Y2LS             7 0                      MD023629
     C**********         PARM      *BLANKS       @INVL            25                        MD023629
     C**********         MOVE      0             X                 1 0                      MD023629
     C**********         EVAL      X = %LOOKUP(%TRIM(@INVL):RECONSTAT)                      MD023629
     C**********         IF        X > 0                                                    MD023629
     C**********         EVAL      #1POS2 = %Trim(%Xlate(LO:UP:RECONDESC(X)))               MD023629
     C**********         ELSE                                                               MD023629
     C**********         EVAL      #1POS2 = *BLANKS                                         MD023629
     C**********         ENDIF                                                              MD023629
     C**********         ENDIF                                                              MD023629

     C                   IF        #1POS2 <> *BLANK  AND  WPOS2 <> #1POS2
     C                             AND WSkipRec = 'N'
     C                   EVAL      POS = %Scan(%Trim(#1POS2):WPOS2)
     C                   IF        POS = 0
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF

     C**********         ENDIF                                                              MD023629

      ** Currency
     C**********         IF        #1POS1 <> *BLANK                                         MD023629
      ***Name*search required?                                                              MD023629
     C*****'?'**         SCAN      #1POS1                                 78                MD023629
     C**********         IF        *IN78 = *ON AND W0RTN <> 'Y2U0016'                       MD023629
     C**********         CALL      'SD0020S'                                Select Currency MD023629
     C**********         PARM      *BLANK        W0RTN             7                        MD023629
     C*****#1POS1        PARM      *BLANK        WQ0003            3        Currency Code   MD023629
     C**********         ENDIF                                                              MD023629

     C                   IF        #1POS1 <> *BLANK AND #1POS1 <> B_ARNRCCY
     C                                  + B_ARNRNCD                                         MD029683
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF

     C**********         ENDIF                                                              MD023629

      ** End Mode
     C**********         ENDIF                                                              MD023629

     C                   IF        WSkipRec = 'N'

      ** Clear subfile fields

     C                   EXSR      SRClrScrn

      ***If*CHANGE mode, load subfile fields                                                MD023629
      **********                                                                            MD023629
     C**********         IF        W1PMD <> 'ADD'                                           MD023629
     C                   EXSR      SRMove

     C**********         ENDIF                                                              MD023629

      ** Output to subfile

     C                   ADD       1             SRLRN                                      MD023629
     C                   ADD       1             WRCTR                81
     C                   EVAL      *IN81 = *ON

      ***If*SFLRCD invalid, note that errors present                                        MD023629
      **********                                                                            MD023629
     C**********         IF        *IN83 = *ON and *IN40 = '0'                              MD023629
     C**********         EVAL      *IN40 = *ON                                              MD023629
     C**********         ENDIF                                                              MD023629

     C                   WRITE     GL000593S1

     C**********         ELSE                                                               MD023629
     C**********         SUB       1             SRLRN                                      MD023629
     C                   ENDIF

      ** End of File

     C**********         IF        W1PMD <> 'ADD'                                           MD023629

     C/exec SQL
     C+ fetch next
     C+ from NostroRecon
     C+ into : ARNR
     C/end-exec

     C                   IF        %Subst(SQLState:1:2) = '02'
     C                   EVAL      *IN82 = *ON
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF

     C**********         ENDIF                                                              MD023629

     C                   ENDDO

     C                   Z-ADD     SRLRN         WLRCD

     C**********         IF        INVALID = 'Y'                                            MD023629
     C**********         EVAL      *IN34 = *ON                                              MD023629
     C**********         EVAL      PZMsgFile = 'GBSDUSRMSG'                                 MD023629
     C**********         EVAL      PZMsgID = 'USR0805'                                      MD023629
     C**********         EXSR      SRZasnms                                                 MD023629
     C**********         EVAL      *IN40 = *ON                                              MD023629
     C**********         ENDIF                                                              MD023629

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *****************************************************************

     C     SRDisplay     BEGSR

      ***Set*screen conditioning indicators                                                 MD023629
      **********                                                                            MD023629
     C**********         IF        W1PMD = 'ADD'                                            MD023629
     C**********         EVAL      *IN89 = *ON                                              MD023629
     C**********         ELSE                                                               MD023629
     C**********         EVAL      *IN89 = *OFF                                             MD023629
     C**********         ENDIF                                                              MD023629
      **********                                                                            MD023629
      ***PUTOVR*unless conditioned fields change                                            MD023629
      **********                                                                            MD023629
     C**********         IF        *IN89 <> CAIN89 OR *IN81 <> CAIN81                       MD023629
     C**********         EVAL      *IN86 = *OFF                                             MD023629
     C**********         ENDIF                                                              MD023629
      **********                                                                            MD023629
     C**********         EVAL      CAIN89 = *IN89                                           MD023629
     C**********         EVAL      CAIN81 = *IN81                                           MD023629
      **********                                                                            MD023629
      ***Display appropriate Header depending upon Mode whether it is                       MD023629
      ***Enquiry or Maintenance                                                             MD023629
      **********                                                                            MD023629
     C**********         IF        PMODE = 'E'                                              MD023629
     C**********         EVAL      *IN31 = *ON                                              MD023629
     C**********         ENDIF                                                              MD023629

      ***Display*appropriate Header depending upon Mode whether it is                       MD023629
      ***Enquiry*or Maintenance                                                             MD023629

      ***Set*cursor*by**SET CURSOR data                                                     MD023629

     C                   EVAL      *IN26 = *OFF                                             MD023629
     C                   EVAL      *IN28 = *OFF                                             MD023629
     C                   EVAL      *IN29 = *OFF                                             MD023629
      *                                                                                     MD023629
     C                   IF        WScreen = '1'                                            MD023629
     C                   EVAL      *IN26 = *ON                                              MD023629
     C                   ELSE                                                               MD023629
     C                   EVAL      *IN28 = *ON                                              MD023629
     C                   IF        #1ACTN = 'D'                                             MD023629
     C                   EVAL      *IN29 = *ON                                              MD023629
     C                   ENDIF                                                              MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
     C                   TIME                    #1TIME
     C                   WRITE     GL000593C2
     C                   WRITE     GL000593F1
     C                   IF        WScreen = '1'                                            MD023629
     C                   EXFMT     GL000593C1
     C                   ELSE                                                               MD023629
     C                   EXFMT     GL000593F3                                               MD023629
     C                   ENDIF                                                              MD023629

      ** Clear messages from program message queue

     C                   CALL      'ZA0250'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process Screen Input                              *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR

      ** Change of position specified

     C**********         IF        W1PMD <> 'ADD' and WPOSN <> SPOSN                        MD023629
     C**********                   OR WZCCY <> #1POS1 OR WZNCD <> #1POS3                    MD023629
     C**********                   OR WZSTS <> #1POS2 OR WZBRC <> #1POS4                    MD023629
     C**********                                                                            MD023629
     C**********         EXSR      SRReload                                                 MD023629
     C**********         ENDIF                                                              MD023629
      **********                                                                            MD023629
      ***Quit*if reload requested                                                           MD023629
      **********                                                                            MD023629
     C**********         IF        W1RSF <> 'Y'                                             MD023629
      **********                                                                            MD023629
     C**********         IF        *IN81 = *ON                                              MD023629
     C**********         EVAL      WKIPIN = 'N'                                             MD023629
     C**********         ENDIF                                                              MD023629

      ** Validate action code                                                               MD023629
      *                                                                                     MD023629
     C                   EVAL      *IN40 = *OFF                                             MD023629
     C                   EXSR      SRVAction                                                MD023629

      ** Process subfile records

     C**********         EXSR      SRProcRec                                                MD023629
     C  N40              EXSR      SRProcRec                                                MD023629

     C  N40              EXSR      SRReload                                                 MD023629
      ***Switch*between *ADD/*CHANGE modes is allowed when no errors                        MD023629
      ***exists*during update                                                               MD023629
      **********                                                                            MD023629
     C**********         IF        *IN40 = *OFF                                             MD023629
     C**********         EXSR      SRMode                                                   MD023629
     C**********         ENDIF                                                              MD023629

     C**********         ENDIF                                                              MD023629

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcRec - Process Request                                   *
      *                                                               *
      *****************************************************************
     C     SRProcRec     BEGSR

     C**********         EVAL      #1CCY = *BLANKS                                          MD023629
     C**********         EVAL      #1NOSC = *BLANKS                                         MD023629
     C**********         EVAL      #1ANAM = *BLANKS                                         MD023629
     C**********         EVAL      #1BRCH = *BLANKS                                         MD023629
      **********                                                                            MD023629
     C**********         IF        W1PMD = 'CHG' AND PZMsgID <> 'USR7590'                   MD023629
      **********                                                                            MD023629
      ***If*subfile is empty, resend message                                                MD023629
      **********                                                                            MD023629
     C**********         IF        WLRCD = *ZEROS                                           MD023629
     C**********         EVAL      PZMsgFile = 'GBSDUSRMSG'                                 MD023629
     C**********         EVAL      PZMsgFile = 'SDUSRMSG'                                   MD023629
     C**********         EVAL      PZMsgID = 'USR7590'                                      MD023629
     C**********         EXSR      SRZasnms                                                 MD023629
     C**********         ENDIF                                                              MD023629
      **********                                                                            MD023629
     C**********         ENDIF                                                              MD023629
      **********                                                                            MD023629
     C**********         EVAL      *IN84 = *OFF                                             MD023629
     C**********         EVAL      *IN89 = *OFF                                             MD023629
      *                                                                                     MD023629
      ** Process modified subfile record                                                    MD023629
      *                                                                                     MD023629
     C                   READC     GL000593S1                             85                MD023629
      *                                                                                     MD023629
     C                   DOW       *IN85 = *OFF                                             MD023629
      *                                                                                     MD023629
      ** Display details screen.                                                            MD023629
      *                                                                                     MD023629
     C                   SELECT                                                             MD023629
     C                   WHEN      #1ACTN = 'E'                                             MD023629
     C                   EVAL      #2ACTN = 'Enquiry'                                       MD023629
     C                   WHEN      #1ACTN = 'D'                                             MD023629
     C                   EVAL      #2ACTN = 'Delete new Batch Id'                           MD023629
     C                   WHEN      #1ACTN = 'R'                                             MD023629
     C                   EVAL      #2ACTN = 'Restart old Batch Id'                          MD023629
     C                   ENDSL                                                              MD023629
      *                                                                                     MD023629
     C**********         EVAL      #2NOST = #1CCY + #1NOSC                         MD023629 MD029683
     C                   EVAL      #2NOST = #1NOST                                          MD029683
     C                   EVAL      #2ANAM = #1ANAM                                          MD023629
     C                   EVAL      #2BRCH = #1BRCH                                          MD023629
     C                   EVAL      #2LSTN = #1LSTN                                          MD023629
     C                   EVAL      #2LSTS = #1LSTS                                          MD023629
                                                                                            MD029683
     C                   IF        #1JRNB <> *Blanks                                        MD029683
      *                                                                                     MD029683
     C/exec sql                                                                             MD029683
     C+ declare BatchNum2 Scroll Cursor                                                     MD029683
     C+  for select BHBTNB                                                                  MD029683
     C*+*from*GLACBHTD                                                             MD029683 MD023629
     C+  from DIACBHTD                                                                      MD023629
     C+  where BHBTID =: #0BATD                                                             MD029683
     C+  order by BHBTNB desc                                                               MD029683
     C/end-exec                                                                             MD029683
                                                                                            MD029683
     C/exec sql                                                                             MD029683
     C+ open BatchNum2                                                                      MD029683
     C/end-exec                                                                             MD029683
                                                                                            MD029683
     C                   MOVE      *BLANKS       WHBTCH                                     MD029683
     C                   MOVE      1             X                                          MD029683
     C                   EVAL      #2JRNB = *Blanks                                         MD029683
                                                                                            MD029683
     C/exec SQL                                                                             MD029683
     C+ fetch next                                                                          MD029683
     C+ from BatchNum2                                                                      MD029683
     C+ into : WHBTCH                                                                       MD029683
     C/end-exec                                                                             MD029683
                                                                                            MD029683
     C                   DOW       SQLCODE = 0 AND X <= 10                                  MD029683
     C                   IF        #2JRNB = *Blanks                                         MD029683
     C                   EVAL      #2JRNB = WHBTCH                                          MD029683
     C                   ELSE                                                               MD029683
     C                   EVAL      #2JRNB = %TRIM(#2JRNB) + ' ' + WHBTCH                    MD029683
     C                   ENDIF                                                              MD029683
     C/exec SQL                                                                             MD029683
     C+ fetch next                                                                          MD029683
     C+ from BatchNum                                                                       MD029683
     C+ into : WHBTCH                                                                       MD029683
     C/end-exec                                                                             MD029683
     C                   EVAL      X = X + 1                                                MD029683
     C                   ENDDO                                                              MD029683
     C/exec sql                                                                             MD029683
     C+ close BatchNum2                                                                     MD029683
     C/end-exec                                                                             MD029683
     C                   ENDIF                                                              MD029683
                                                                                            MD029683
     C                   EVAL      #2LDAT = #1LDAT                                          MD023629
     C                   EVAL      #2LTIM = #1LTIM                                          MD023629
     C                   EVAL      #2BATD = #0BATD                                          MD023629
     C                   EVAL      #2STAT = #1STAT                                          MD023629
     C                   EVAL      #2ERCD = #1ERCD                                          MD023629
      *                                                                                     MD023629
      ** Display screen while there is an issue                                             MD023629
      *                                                                                     MD023629
     C                   DOU       NOT *IN40                                                MD023629
      *                                                                                     MD023629
     C                   EVAL      *IN40 = *OFF                                             MD023629
      *                                                                                     MD023629
     C                   EVAL      WScreen = '2'                                            MD023629
      *                                                                                     MD023629
     C                   EXSR      SRDisplay                                                MD023629
      *                                                                                     MD023629
      ** Handle action                                                                      MD023629
      *                                                                                     MD023629
     C                   SELECT                                                             MD023629
      ** Exit                                                                               MD023629
     C                   WHEN      *IN03                                                    MD023629
     C                   EXSR      SREnd                                                    MD023629
      *                                                                                     MD023629
      ** Previous                                                                           MD023629
     C                   WHEN      *IN12                                                    MD023629
      *                                                                                     MD023629
      ** Delete without F10                                                                 MD023629
      *                                                                                     MD023629
     C                   WHEN      #1ACTN = 'D' AND NOT *IN10                               MD023629
     C                   EVAL      *IN40 = *ON                                              MD023629
     C                   EVAL      PZMsgID = 'CGL0224'                                      MD023629
     C                   EVAL      PZMsgFile = 'GLUSRMSG'                                   MD023629
     C                   EXSR      SRZasnms                                                 MD023629
      *                                                                                     MD023629
      ** Delete                                                                             MD023629
      *                                                                                     MD023629
     C                   WHEN      #1ACTN = 'D' AND *IN10                                   MD023629
      *                                                                                     MD023629
     C                   CALL      'GLC000599'                                              MD023629
     C                   PARM      *BLANKS       PRTCD                          Return code MD023629
     C                   PARM      #0BATD        PBTID                          Batch ID    MD023629
     C                   PARM      #0TMST        PTMST                          Time Stamp  MD023629
      *                                                                                     MD023629
     C                   IF        PRTCD = 'PROCESS'                                        MD023629
     C                   EVAL      *IN40 = *ON                                              MD023629
     C                   EVAL      PZMsgFile = 'GLUSRMSG'                                   MD023629
     C                   EVAL      PZMsgID = 'CGL0219'                                      MD023629
     C                   EXSR      SRZasnms                                                 MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
      ** Restart                                                                            MD023629
      *                                                                                     MD023629
     C                   WHEN      #1ACTN = 'R'                                             MD023629
      *                                                                                     MD023629
     C                   MOVEL(P)  #0BATD        PPARM100                       Batch ID    MD023629
     C                   CALL      'GLC000597'                                              MD023629
     C                   PARM      *BLANKS       PRTCD                          Return code MD023629
     C                   PARM                    PPARM100                       Batch ID    MD023629
      *                                                                                     MD023629
     C                   IF        PRTCD = 'PROCESS'                                        MD023629
     C                   EVAL      *IN40 = *ON                                              MD023629
     C                   EVAL      PZMsgFile = 'GLUSRMSG'                                   MD023629
     C                   EVAL      PZMsgID = 'CGL0219'                                      MD023629
     C                   EXSR      SRZasnms                                                 MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
     C                   ENDSL                                                              MD023629
      *                                                                                     MD023629
     C                   ENDDO                                                              MD023629
      *                                                                                     MD023629
     C                   EVAL      *IN84 = *OFF                                             MD023629
     C                   EVAL      #1ACTN = *BLANKS                                         MD023629
      *                                                                                     MD023629
     C                   UPDATE    GL000593S1                                               MD023629
      *                                                                                     MD023629
     C                   READC     GL000593S1                             85                MD023629
      *                                                                                     MD023629
     C                   ENDDO                                                              MD023629

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **********                                                      *                     MD023629
      **SRMode*- Switch Between *ADD and *CHANGE Modes                *                     MD023629
      **********                                                      *                     MD023629
      *****************************************************************                     MD023629
     C*****SRMode        BEGSR                                                              MD023629
      **********                                                                            MD023629
      ***Switch*between *ADD/*CHANGE modes                                                  MD023629
      ***Note*that this is SR was retained for the                                          MD023629
      ***purpose that an ADD mode might be needed for future use                            MD023629
      **********                                                                            MD023629
     C**********         EVAL      SPOSN = *BLANKS                                          MD023629
      **********                                                                            MD023629
     C**********         EXSR      SRReload                                                 MD023629
      **********                                                                            MD023629
     C**********         ENDSR                                                              MD023629
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      *****************************************************************
     C     SRReload      BEGSR

      ** Request subfile reload

     C                   EVAL      W1RSF = 'Y'

     C                   IF        *IN05 = *ON
     C                   EVAL      SPOSN = *BLANKS
     C**********         EVAL      #1POS1 = *Blanks                                         MD023629
     C**********         EVAL      #1POS2 = *Blanks                                         MD023629
     C**********         EVAL      #1POS3 = *Blanks                                         MD023629
     C**********         EVAL      #1POS4 = *Blanks                                         MD023629
     C**********         EVAL      #1POS5 = *Blanks                                         MD023629
     C                   ENDIF                                                              MD023629
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF                                             MD029683
     C                   EVAL      *IN36 = *OFF                                             MD029683
     C**********         ENDIF                                                              MD023629

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrScrn - Initialise Subfile Record                         *
      *                                                               *
      *****************************************************************
     C     SRClrScrn     BEGSR

      ** Initialise subfile record

     C**********         EVAL      #1CCY  = *BLANKS                                         MD029683
     C**********         EVAL      #1NOSC = *BLANKS                                         MD029683
     C                   EVAL      #1NOST = *BLANKS                                         MD029683
     C                   EVAL      #1ANAM = *BLANKS
     C                   EVAL      #1BRCH = *BLANKS
     C                   EVAL      #1LSTN = *BLANKS
     C                   EVAL      #1LSTS = *BLANKS
     C                   EVAL      #1LDAT = *BLANKS
     C                   EVAL      #1LTIM = *BLANKS
     C                   EVAL      #1STAT = *BLANKS
     C                   EVAL      #1ERCD = *BLANKS
     C                   EVAL      #1SLSH1 = *BLANKS
     C                   EVAL      #1SLSH2 = *BLANKS
     C                   EVAL      #1ACID = *BLANKS                                         MD029683
     C                   EVAL      #1ANUM = *BLANKS                                         MD029683
     C                   EVAL      #1JRNB = *BLANKS                                         MD029683
     C                   EVAL      #0BATD  = *BLANKS                                        MD023629
     C                   EVAL      #0NBTF  = *BLANKS                                        MD023629
     C                   EVAL      #0TMST  = *BLANKS                                        MD023629
     C                   EVAL      #1ACTN  = *BLANKS                                        MD023629

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **SRMove*-*Transfer*Records*from*GLARNRTD*to*Subfile*************                     MD029739
      * SRMove - Transfer Records from DIARNRTD to Subfile            *                     MD029739
      *                                                               *
      *****************************************************************
     C     SRMove        BEGSR

      ***Move*GLARNRTD*fields*to*subfile*******************************                     MD029739
      ** Move DIARNRTD fields to subfile                                                    MD029739

     C                   EVAL      #1SLSH1 = '/'
     C                   EVAL      #1SLSH2 = '/'
      ***Currency**                                                                         MD029683
      ** Nostro                                                                             MD029683
     C**********         EVAL      #1CCY  = B_ARNRCCY                                       MD029683
     C                   EVAL      #1NOST = B_ARNRCCY + B_ARNRNCD                           MD029683

      ***Nostro*Code***                                                                     MD029683
     C**********         EVAL      #1NOSC = B_ARNRNCD                                       MD029683

      ** Get Nostro Details via AONOSTR0

     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @CNUM             6
     C                   PARM      B_ARNRCCY     @CCYD             3
     C                   PARM      *BLANKS       @ACOD            10
     C                   PARM      *BLANKS       @ASEQ             2
     C                   PARM      B_ARNRNCD     @NOST             2
     C                   PARM      *BLANKS       @BRCA             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSSDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A7CUST        @CNUM
     C                   MOVE      A7CYCD        @CCYD
     C                   MOVE      A7ACCD        @ACOD
     C                   MOVE      A7ACSN        @ASEQ
     C                   MOVE      A7BRCD        @BRCA
     C                   ENDIF

     C     @RTCD         IFEQ      *BLANKS                                                  MD029683
                                                                                            MD029683
      **Get Account Details via AOACCTR0

     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      *BLANKS       @ACNO            10
     C                   PARM                    @CNUM
     C                   PARM                    @CCYD
     C                   PARM                    @ACOD
     C                   PARM                    @ASEQ
     C                   PARM                    @BRCA
     C     SDACCT        PARM      SDACCT        DSSDY

      ** Account Name

     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      #1ANAM = A_ANAM
     C                   ENDIF

      ** Account Branch
     C                   EVAL      #1BRCH = @BRCA
                                                                                            MD029683
     C                   ENDIF                                                              MD029683

      ** Last Bank Statement Number
     C                   MOVE      B_ARNRLSN     #1LSTN

      ** Last Bank Statement Sequence
     C                   MOVE      B_ARNRLSS     #1LSTS

      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMMYY format.
     C                   EVAL      PZDayNo = B_ARNRDAT
     C                   CALL      'ZDATE2'
     C                   PARM                    PZDayNo
     C**********         PARM                    PBJDFIN                                    MD023629
     C                   PARM      BJDFIN        PBJDFIN                                    MD023629
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate

      ** Date Last Initiated
     C                   MOVE      PZADate       #1LDAT

      ** Time Last Initiated
     C                   MOVE      B_ARNRTIM     WTIME
     C                   EVAL      #1LTIM = WHR + ':' + WMIN + ':' + WSEC

      ** Account ID                                                                         MD029683
      *                                                                                     MD035766
     C                   IF        B_ARNBTID <> XFBTID                                      MD035766
     C                   MOVEL     B_ARNOACN     WFACID                                     MD035766
     C                   ENDIF                                                              MD035766
      *                                                                                     MD035766
     C                   MOVE      WFACID        #1ACID                                     MD029683
                                                                                            MD029683
      ** Account Number                                                                     MD029683
     C     @RTCD         IFEQ      *BLANKS                                                  MD029683
     C                   MOVEL     *BLANKS       #1ANUM                                     MD029683
                                                                                            MD029683
     C                   IF        A_ACNO <> 0                                              MD029683
     C                   MOVEL     A_ACNO        #1ANUM                                     MD029683
     C                   ELSE                                                               MD029683
     C                   MOVE      A_ACOD        WACOD                                      MD029683
     C                   MOVE      A_ACSQ        WACSQ                                      MD029683
     C                   EVAL      #1ANUM =  A_CNUM + A_CCY + WACOD +                       MD029683
     C                                       WACSQ                                          MD029683
     C                   ENDIF                                                              MD029683
     C                   ENDIF                                                              MD029683
                                                                                            MD029683
      ** Status
     C                   EVAL      #1STAT = B_ARNRSTS
      *                                                                                     MD023629
      ** SRBTCP  -  Check if batch completed                                                MD023629
      *                                                                                     MD023629
     C                   EXSR      SRBTCP                                                   MD023629

      ** Error Code
     C                   EVAL      #1ERCD = B_ARNRERC
     C                   IF        B_ARNRERC <> *BLANKS                                     MD023629
     C                   CALLB     'ZAMSGRTVMS'                                             MD023629
     C                   PARM      *BLANKS       PRTCD                                      MD023629
     C                   PARM                    CompMsg                                    MD023629
     C                   PARM      B_ARNRERC     #MsgId                                     MD023629
     C                   PARM      *BLANKS       #MsgData                                   MD023629
     C                   PARM      'GLUSRMSG'    #MsgFile                                   MD023629
     C                   PARM      '*LIBL'       #MsgFLib                                   MD023629
     C                   PARM      '1'           Level                                      MD023629
     C                   IF        PRTCD = *BLANKS                                          MD023629
     C                   EVAL      #1ERCD = CompMsg                                         MD023629
     C                   ELSE                                                               MD029683
     C                   EVAL      #1ERCD = 'Unknown Error Code: ' +                        MD029683
     C                                      %Trim(B_ARNRERC)                                MD029683
     C                   ENDIF                                                              MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
      ** Last Batch ID                                                                      MD023629
      *                                                                                     MD023629
     C                   EVAL      #0BATD = B_ARNBTID                                       MD023629
      *                                                                                     MD023629
      ** Batch Header Number                                                                MD029683
      *                                                                                     MD029683
     C                   IF        B_ARNRSTS = 'Journal Batch Accepted' or                  MD029683
     C                             B_ARNRSTS = 'Journal Batch Held' or                      MD029683
     C                             B_ARNRSTS = 'Real Time Post' or                          MD029683
     C                             B_ARNRSTS = 'Real Time Post Failed' or                   MD029683
     C                             B_ARNRSTS = 'MT940 Production' or                        MD029683
     C                             B_ARNRSTS = 'Complete'                                   MD029683
      *                                                                                     MD029683
     C/exec sql                                                                             MD029683
     C+ declare BatchNum Scroll Cursor                                                      MD029683
     C+  for select BHBTNB                                                                  MD029683
     C*+*from*GLACBHTD                                                             MD029683 MD023629
     C+  from DIACBHTD                                                                      MD023629
     C+  where BHBTID =: B_ARNBTID                                                          MD029683
     C+  order by BHBTNB desc                                                               MD029683
     C/end-exec                                                                             MD029683
                                                                                            MD029683
     C/exec sql                                                                             MD029683
     C+ open BatchNum                                                                       MD029683
     C/end-exec                                                                             MD029683
                                                                                            MD029683
     C                   MOVE      *BLANKS       #1JRNB                                     MD029683
                                                                                            MD029683
     C/exec SQL                                                                             MD029683
     C+ fetch next                                                                          MD029683
     C+ from BatchNum                                                                       MD029683
     C+ into : #1JRNB                                                                       MD029683
     C/end-exec                                                                             MD029683
                                                                                            MD029683
     C/exec SQL                                                                             MD029683
     C+ close BatchNum                                                                      MD029683
     C/end-exec                                                                             MD029683
     C                   ENDIF                                                              MD029683
      *                                                                                     MD029683
      ** New Batch Id Flag                                                                  MD023629
      *                                                                                     MD023629
     C                   IF        WTimeStamp = *Blanks                                     MD023629
     C                   EVAL      #0NBTF = 'N'                                             MD023629
     C                   ELSE                                                               MD023629
     C                   EVAL      #0NBTF = 'Y'                                             MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
      ** Timestamp                                                                          MD023629
      *                                                                                     MD023629
     C                   EVAL      #0TMST = WTimeStamp                                      MD023629

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                MD023629
      *****************************************************************                     MD023629
      *                                                               *                     MD023629
      **SrACME*-*Retrieve*detail*from*holding*file*(IGACMETD)**********            MD023629 MD029739
      * SrACME - Retrieve detail from holding file (DIACMETD)         *                     MD029739
      *                                                               *                     MD023629
      *****************************************************************                     MD023629
     C     SrACME        BEGSR                                                              MD023629
      *                                                                                     MD023629
      ***Setup*key*to*access*IGACMETD**********************************           MD023629  MD029739
      ** Setup key to access DIACMETD                                                       MD029739
      *                                                                                     MD023629
     C**********         MOVEL     SELFLD        K_SELFLD                          MD023629 MD029683
     C**********         MOVEL     B_ARNOACN     K_SELFL2                          MD023629 MD029683
      *                                                                                     MD023629
     C/EXEC SQL                                                                             MD023629
     C+ SELECT * INTO :DSACMETD                                                             MD023629
     C*+from*IGACMETD                                                              MD023629 MD029739
     C+ from DIACMETD                                                                       MD029739
     C**********+ Where SUBSTR(XFBTID,1,8) = :K_SELFLD                             MD023629 MD029683
     C**********+ and SUBSTR(XFBTID,16,35) = :K_SELFL2                             MD023629 MD029683
     C+ Where XFBTID = :B_ARNBTID                                                           MD029683
     C+ ORDER BY XFBTID DESC                                                                MD023629
     C+ Fetch first 1 row only                                                              MD023629
     C/END-EXEC                                                                             MD023629
      *                                                                                     MD023629
      ** If new batch Id                                                                    MD023629
      *                                                                                     MD023629
     C**********         IF        SQLCODE = 0 AND                                 MD023629 MD029683
     C**********                   XFBTID  > B_ARNBTID                             MD023629 MD029683
     C                   IF        SQLCODE = 0                                              MD029683
      *                                                                                     MD023629
      ** Extract Time Stamp                                                                 MD023629
      *                                                                                     MD023629
     C                   EVAL      WTimeStamp =  XFTMSP                                     MD023629
      *                                                                                     MD023629
      ** Last Batch ID                                                                      MD023629
      *                                                                                     MD023629
     C**********         EVAL      B_ARNBTID =   XFBTID                            MD023629 MD029683
      *                                                                                     MD023629
      ** Last Bank Stmt No.                                                                 MD023629
      *                                                                                     MD023629
     C                   MOVE      XFSTMT        B_ARNRLSN                                  MD023629
      *                                                                                     MD023629
      ** Last Bank Stmt Seq.                                                                MD023629
      *                                                                                     MD023629
     C                   MOVE      XFPGNM        B_ARNRLSS                                  MD023629
      *                                                                                     MD023629
      ** Date Last Initiated                                                                MD023629
      *                                                                                     MD023629
     C                   IF        B_ARNRDAT = *Zeros                                       MD029683
     C                   MOVEL     XFTMSP        ExtTmsTmp                                  MD023629
     C                   MOVE      ExtYY         ZWYYYY                                     MD023629
     C                   MOVE      ExtMM         ZWMTH                                      MD023629
     C                   MOVE      ExtDD         ZWDAY                                      MD023629
     C                   CALL      'ZDATE10'                                                MD023629
     C                   PARM      ZZDTIN        DateIn                                     MD023629
     C                   PARM      *ZEROS        DaynoOut          5 0                      MD023629
     C                   EVAL      B_ARNRDAT =   DaynoOut                                   MD023629
     C                   ENDIF                                                              MD029683
      *                                                                                     MD023629
      ** Time Last Initiated                                                                MD023629
      *                                                                                     MD023629
     C                   IF        B_ARNRTIM = *Zeros                                       MD029683
     C                   EVAL      B_ARNRTIM =   (ExtHH * 10000)                            MD023629
     C                                         + (ExtMN * 100)                              MD023629
     C                                         + (ExtSC)                                    MD023629
     C                   ENDIF                                                              MD029683
      *                                                                                     MD023629
      ** Error Code                                                                         MD023629
      *                                                                                     MD023629
     C**********         EVAL      B_ARNRERC = *Blanks                             MD023629 MD029683
      *                                                                                     MD023629
      ** Account ID                                                                         MD029683
      *                                                                                     MD029683
     C                   MOVEL     XFACID        WFACID                                     MD029683
      *                                                                                     MD029683
      ** Clear message request details                                                      MD023629
      *                                                                                     MD023629
     C                   EVAL      B_ARNSORQ  =  *Blanks                                    MD023629
     C                   EVAL      B_ARNSDTE  =  *Zeros                                     MD023629
     C                   EVAL      B_ARNSTIM  =  *Zeros                                     MD023629
     C                   EVAL      B_ARNRDTE  =  *Zeros                                     MD023629
     C                   EVAL      B_ARNSRTIM =  *Blanks                                    MD023629
      *                                                                                     MD023629
      ** Status                                                                             MD023629
      *                                                                                     MD023629
     C                   SELECT                                                             MD023629
      *                                                                                     MD023629
      **   In process                                                                       MD023629
      *                                                                                     MD023629
     C                   WHEN      XFPRSD = 'Y'                                             MD023629
     C                             and B_ARNRSTS = *Blanks                                  MD029683
     C                   EVAL      B_ARNRSTS  = RECONDESC(11)                               MD023629
      *                                                                                     MD023629
      **   Initiated                                                                        MD023629
      *                                                                                     MD023629
     C                   WHEN      XFPRSD = 'N'                                             MD023629
     C                             and B_ARNRSTS = *Blanks                                  MD029683
     C                   EVAL      B_ARNRSTS  = RECONDESC(10)                               MD023629
     C                   ENDSL                                                              MD023629
      *                                                                                     MD023629
      **   Check if the last record of batch in the holding file                            MD023629
      **   has the status 'S' Submitted to Midas (retrieve by Time Stamp)                   MD023629
      *                                                                                     MD023629
     C/EXEC SQL                                                                             MD023629
     C+ SELECT XFPRSD INTO :WStat                                                           MD023629
     C*+from*IGACMETD                                                              MD023629 MD029739
     C+ from DIACMETD                                                                       MD029739
     C+ where XFTMSP = :WTimeStamp                                                          MD023629
     C+   and XFPRSD = 'S'                                                                  MD023629
     C+   and XFBTID = :B_ARNBTID                                                           MD029683
     C+ Fetch First 1 row only                                                              MD023629
     C/END-EXEC                                                                             MD023629
      *                                                                                     MD023629
     C                   IF        SQLCODE   = 0 AND                                        MD023629
     C                             WStat     = 'S'                                          MD023629
     C                             and B_ARNRSTS = *Blanks                                  MD029683
     C                   EVAL      B_ARNRSTS = RECONDESC(12)                                MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
     C                   ENDSR                                                              MD023629
      *****************************************************************                     MD023629
      /EJECT                                                                                MD023629
      *****************************************************************                     MD023629
      *                                                               *                     MD023629
      *  SRBTCP  -  Check if batch completed                          *                     MD023629
      *                                                               *                     MD023629
      *****************************************************************                     MD023629
     C     SRBTCP        BEGSR                                                              MD023629
      *                                                                                     MD023629
      ** Check if MT940/MT950 has been generated                                            MD023629
      *                                                                                     MD023629
     C                   IF        B_ARNRSTS = RECONDESC(8)                                 MD023629
     C/EXEC SQL                                                                             MD023629
     C+  SELECT * INTO :DSMR94PD                                                            MD023629
     C+  FROM GLMR94PD                                                                      MD023629
     C+  WHERE MRNWRK = :B_ARNNWRK AND                                                      MD023629
     C+        MRBRCA = :B_ARNBRCA AND                                                      MD023629
     C+        MRCNUM = :B_ARNCNUM AND                                                      MD023629
     C+        MRCCY  = :B_ARNRCCY AND                                                      MD023629
     C+        MRACCD = :B_ARNACCD AND                                                      MD023629
     C+        MRACSQ = :B_ARNACSQ AND                                                      MD023629
     C+        MRNATY = :B_ARNNATY AND                                                      MD023629
     C+        MRDSTN = :B_ARNDSTN AND                                                      MD023629
     C+        MRMTPY = :B_ARNMTPY AND                                                      MD023629
     C+        MRSORQ = :B_ARNSORQ AND                                                      MD023629
     C+        MRSDTE = :B_ARNSDTE AND                                                      MD023629
     C+        MRSTIM = :B_ARNSTIM AND                                                      MD023629
     C+        MRRDTE = :B_ARNRDTE AND                                                      MD023629
     C+        MRSRTIM = :B_ARNSRTIM                                                        MD023629
     C/END-EXEC                                                                             MD023629
      *                                                                                     MD023629
     C                   IF        SQLCODE = 0 AND                                          MD023629
     C                             MRSTAT = 'GENERATED'                                     MD023629
     C                   EVAL      #1STAT = RECONDESC(9)                                    MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
     C                   ENDSR                                                              MD023629
      *****************************************************************                     MD023629
      /EJECT                                                                                MD023629
      *****************************************************************                     MD023629
      *                                                               *                     MD023629
      *  SRVAction - Validate Action Codes                            *                     MD023629
      *                                                               *                     MD023629
      *****************************************************************                     MD023629
      *                                                                                     MD023629
     C     SRVAction     BEGSR                                                              MD023629
      *                                                                                     MD023629
      ** Process modified subfile record                                                    MD023629
      *                                                                                     MD023629
     C                   READC     GL000593S1                             85                MD023629
      *                                                                                     MD023629
     C                   DOW       *IN85 = *OFF                                             MD023629
      *                                                                                     MD023629
     C                   EVAL      *IN70 = *OFF                                             MD023629
      *                                                                                     MD023629
      ** Action code must be 'E', 'D' or 'R'                                                MD023629
      *                                                                                     MD023629
     C                   IF        #1ACTN <> 'D'  AND  #1ACTN <> *BLANK AND                 MD023629
     C                             #1ACTN <> 'R'  AND  #1ACTN <> 'E'                        MD023629
     C                   EVAL      *IN40 = *ON                                              MD023629
     C                   EVAL      *IN70 = *ON                                              MD023629
     C                   EVAL      PZMsgID = 'USR7591'                                      MD023629
     C                   EVAL      PZMsgFile = 'SDUSRMSG'                                   MD023629
     C                   EXSR      SRZasnms                                                 MD023629
     C                   GOTO      EndVal                                                   MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
      ** Check for user's authority                                                         MD023629
      *                                                                                     MD023629
     C                   IF        #1ACTN <> *BLANK                                         MD023629
     C                   EXSR      SrAUTH                                                   MD023629
     C   70              GOTO      EndVal                                                   MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
      ** If action 'D', must be for New Batch only                                          MD023629
      *                                                                                     MD023629
     C                   IF        #1ACTN = 'D' AND                                         MD023629
     C                             #0NBTF = 'N'                                             MD023629
     C                   EVAL      *IN40 = *ON                                              MD023629
     C                   EVAL      *IN70 = *ON                                              MD023629
     C                   EVAL      PZMsgID = 'CGL0221'                                      MD023629
     C                   EVAL      PZMsgFile = 'GLUSRMSG'                                   MD023629
     C                   EXSR      SRZasnms                                                 MD023629
     C                   GOTO      EndVal                                                   MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
      ** If action 'R',                                                                     MD023629
      *                                                                                     MD023629
     C                   IF        #1ACTN = 'R'                                             MD023629
      *                                                                                     MD023629
     C                   SELECT                                                             MD023629
      *                                                                                     MD023629
      ** It must be for Old Batch only                                                      MD023629
      *                                                                                     MD023629
     C**********         WHEN      #0NBTF = 'Y'                                    MD023629 MD029683
     C**********         EVAL      *IN40 = *ON                                     MD023629 MD029683
     C**********         EVAL      *IN70 = *ON                                     MD023629 MD029683
     C**********         EVAL      PZMsgID = 'CGL0220'                             MD023629 MD029683
     C**********         EVAL      PZMsgFile = 'GLUSRMSG'                          MD023629 MD029683
     C**********         EXSR      SRZasnms                                        MD023629 MD029683
     C**********         GOTO      EndVal                                          MD023629 MD029683
      *                                                                                     MD023629
      ** Batch Id must be authorized to next Accounting Rule step                           MD023629
      *                                                                                     MD023629
      ** Batch Id fully processed;                                                          MD023629
      *****Status*-*'Complete'*OR*'Update*MT940',***                               MD023629 MD029683
      **   Status - 'Complete' OR 'MT940 Production',                                       MD029683
      *                                                                                     MD023629
     C                   WHEN      #1STAT = RECONDESC(9) OR                                 MD023629
     C                             #1STAT = RECONDESC(8)                                    MD023629
     C                   EVAL      *IN40 = *ON                                              MD023629
     C                   EVAL      *IN70 = *ON                                              MD023629
     C                   EVAL      PZMsgID = 'CGL0225'                                      MD023629
     C                   EVAL      PZMsgFile = 'GLUSRMSG'                                   MD023629
     C                   EXSR      SRZasnms                                                 MD023629
     C                   GOTO      EndVal                                                   MD023629
      *                                                                                     MD023629
      ** Cannot produce MT940/MT950;                                                        MD023629
      **   System value ProduceMT940 - N & Status - Real Time Post OR Real Time Post Failed MD023629
      *                                                                                     MD023629
     C                   WHEN      WMT94F <> 'Y' AND                                        MD023629
     C                             #1STAT = RECONDESC(6)                                    MD023629
     C                   EVAL      *IN40 = *ON                                              MD023629
     C                   EVAL      *IN70 = *ON                                              MD023629
     C                   EVAL      PZMsgID = 'CGL0226'                                      MD023629
     C                   EVAL      PZMsgFile = 'GLUSRMSG'                                   MD023629
     C                   EXSR      SRZasnms                                                 MD023629
     C                   GOTO      EndVal                                                   MD023629
      *                                                                                     MD023629
      ** Cannot perform Real Time Post;                                                     MD023629
      **   System value AcctRulesRealTimPost - N & Status - Journal Batch Accepted          MD023629
      *                                                                                     MD023629
     C                   WHEN      WRTPF  <> 'Y' AND                                        MD023629
     C                             #1STAT = RECONDESC(4)  OR                                MD023629
     C                             WRTPF  <> 'Y' AND                                        MD023629
     C                             #1STAT = RECONDESC(7)                                    MD023629
     C                   EVAL      *IN40 = *ON                                              MD023629
     C                   EVAL      *IN70 = *ON                                              MD023629
     C                   EVAL      PZMsgID = 'CGL0227'                                      MD023629
     C                   EVAL      PZMsgFile = 'GLUSRMSG'                                   MD023629
     C                   EXSR      SRZasnms                                                 MD023629
     C                   GOTO      EndVal                                                   MD023629
      *                                                                                     MD023629
      ** Cannot Auto-authorize Batch;                                                       MD023629
      **   System value AcctRulesAutoAuth - N & Status Journal Batch Held                   MD023629
      *                                                                                     MD023629
     C                   WHEN      WACAAF <> 'Y' AND                                        MD023629
     C                             #1STAT = RECONDESC(5)                                    MD023629
     C                   EVAL      *IN40 = *ON                                              MD023629
     C                   EVAL      *IN70 = *ON                                              MD023629
     C                   EVAL      PZMsgID = 'CGL0228'                                      MD023629
     C                   EVAL      PZMsgFile = 'GLUSRMSG'                                   MD023629
     C                   EXSR      SRZasnms                                                 MD023629
     C                   GOTO      EndVal                                                   MD023629
      *                                                                                     MD023629
     C                   ENDSL                                                              MD023629
      *                                                                                     MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
     C     EndVal        TAG                                                                MD023629
      *                                                                                     MD023629
     C                   IF        #1ACTN <> *BLANK                                         MD023629
     C                   EVAL      *IN84 = *ON                                              MD023629
     C                   ENDIF                                                              MD023629
      *                                                                                     MD023629
     C                   UPDATE    GL000593S1                                               MD023629
      *                                                                                     MD023629
     C                   EVAL      *IN84 = *OFF                                             MD023629
     C                   EVAL      *IN70 = *OFF                                             MD023629
      *                                                                                     MD023629
     C                   READC     GL000593S1                             85                MD023629
     C                   ENDDO                                                              MD023629
      *                                                                                     MD023629
     C                   ENDSR                                                              MD023629
      *                                                                                     MD023629
      *****************************************************************                     MD023629
      /EJECT                                                                                MD023629
      *****************************************************************                     MD023629
      *                                                               *                     MD023629
      *  SrAUTH   - Check User Authority for action code              *                     MD023629
      *                                                               *                     MD023629
      *****************************************************************                     MD023629
     C     SrAUTH        BEGSR                                                              MD023629
      *                                                                                     MD023629
      ** If Multibranch, call ZVACTBU                                                       MD023629
     C                   IF        BJSBRC = *BLANKS                                         MD023629
      *                                                                                     MD023629
     C                   CALL      'ZVACTBU'                                                MD023629
     C                   PARM      #1ACTN        ZACTN             1                        MD023629
     C                   PARM      #1BRCH        ZBR               3                        MD023629
     C                   PARM                    ERR               1 0                      MD023629
      *                                                                                     MD023629
      ** If Single Bracnh, call ZVACTU                                                      MD023629
     C                   Else                                                               MD023629
      *                                                                                     MD023629
     C                   CALL      'ZVACTU'                                                 MD023629
     C                   PARM      #1ACTN        ZACTN             1                        MD023629
     C                   PARM                    ERR               1 0                      MD023629
     C                   Endif                                                              MD023629
      *                                                                                     MD023629
      **   If action invalid for user                                                       MD023629
      *                                                                                     MD023629
     C                   SELECT                                                             MD023629
     C                   WHEN      ERR = 1                                                  MD023629
     C                   EVAL      *IN40 = *ON                                              MD023629
     C                   EVAL      *IN70 = *ON                                              MD023629
     C                   IF        BJSBRC = *BLANKS                                         MD023629
     C                   EVAL      PZMsgID = 'CGL0222'                                      MD023629
     C                   ELSE                                                               MD023629
     C                   EVAL      PZMsgID = 'CGL0223'                                      MD023629
     C                   ENDIF                                                              MD023629
     C                   EVAL      PZMsgFile = 'GBGLUSRMSG'                                 MD023629
     C                   EXSR      SRZasnms                                                 MD023629
      *                                                                                     MD023629
     C                   WHEN      ERR = 2                                                  MD023629
     C                   EVAL      *IN40 = *ON                                              MD023629
     C                   EVAL      *IN70 = *ON                                              MD023629
     C                   EVAL      PZMsgID = 'CGL0223'                                      MD023629
     C                   EVAL      PZMsgFile = 'GBGLUSRMSG'                                 MD023629
     C                   EXSR      SRZasnms                                                 MD023629
     C                   ENDSL                                                              MD023629
      *                                                                                     MD023629
     C                   ENDSR                                                              MD023629
      *****************************************************************                     MD023629
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      *****************************************************************
     C     SRZasnms      BEGSR

     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR


      ** If selection mode and F3 has been pressed
      ** Terminate program

     C                   EVAL      *INLR = *ON

      ** Exit program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Set up copyright parameter

     C                   MOVEA     CPY@          CPY2@

      ** Receive entry parameters

     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE

     C*****PPAR1         PLIST                                                              MD023629
     C**********         PARM      *BLANKS       PRTCD             7                        MD023629
     C**********         PARM                    PSCRF            16                        MD023629
     C**********         PARM                    PNDEC             1 0                      MD023629
     C**********         PARM                    PNDIG             2 0                      MD023629
     C**********         PARM      *BLANKS       PRVAL            16                        MD023629

      ** Define LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GL000593'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA

     C******DTAARA       DEFINE                  RUNDAT                                     MD023629
     C**********         IN        RUNDAT                                                   MD023629

      ** Obtain default message file

      ** Call Access Program for Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'GL000593'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Retrieve the system value                                                          MD023629
                                                                                            MD023629
     C                   CALL      'AOSVALR0'                                               MD023629
     C                   PARM      *BLANKS       PRTCD                                      MD023629
     C                   PARM      PSysVal1      SVALK1                                     MD023629
     C                   PARM                    SVAL1                                      MD023629
     C                   PARM      PSysVal2      SVALK2                                     MD023629
     C                   PARM                    SVAL2                                      MD023629
     C                   PARM      PSysVal3      SVALK3                                     MD023629
     C                   PARM                    SVAL3                                      MD023629
     C                   PARM                    SVALK4                                     MD023629
     C                   PARM                    SVAL4                                      MD023629
     C                   PARM                    SVALK5                                     MD023629
     C                   PARM                    SVAL5                                      MD023629
     C                   PARM                    SVALK6                                     MD023629
     C                   PARM                    SVAL6                                      MD023629
     C                   PARM                    SVALK7                                     MD023629
     C                   PARM                    SVAL7                                      MD023629
     C                   PARM                    SVALK8                                     MD023629
     C                   PARM                    SVAL8                                      MD023629
     C                   PARM                    SVALK9                                     MD023629
     C                   PARM                    SVAL9                                      MD023629
     C                   PARM                    SVALK0                                     MD023629
     C                   PARM                    SVAL10                                     MD023629
                                                                                            MD023629
      ** If the system values are not found then issue a database error                     MD023629
                                                                                            MD023629
     C     PRTCD         IFNE      '       '                                                MD023629
     C                   EXSR      *PSSR                                                    MD023629
     C                   ENDIF                                                              MD023629
                                                                                            MD023629
      ** Get the Accounting Rules Real Time Post Flag                                       MD023629
                                                                                            MD023629
     C                   MOVEL     ' '           WRTPF                                      MD023629
     C                   EVAL      WRTPF = SVAL1                                            MD023629
                                                                                            MD023629
      ** Get the Produce MT940 Flag                                                         MD023629
                                                                                            MD023629
     C                   MOVEL     ' '           WMT94F                                     MD023629
     C                   EVAL      WMT94F = SVAL2                                           MD023629
                                                                                            MD023629
      ** Get the Accounting Rules Auto Authorise                                            MD023629
                                                                                            MD023629
     C                   MOVEL     ' '           WACAAF                                     MD023629
     C                   EVAL      WACAAF = SVAL3                                           MD023629

      ** Open files for update

     C**********         OPEN      GL000593DF                                               MD029739
     C                   OPEN      DI000593DF                                               MD029739

     C/exec sql
     C+ declare NostroRecon Scroll Cursor
     C+  for select *
     C*+*from*GLARNRTD                                                                      MD029739
     C+  from DIARNRTD                                                                      MD029739
     C+  union all                                                                          MD029683
     C+  select *                                                                           MD029683
     C+  from DIARNXTD                                                                      MD029683
     C+  order by
     C**********+  ARNRCCY, ARNRNCD                                                         MD029683
     C+  ARNRDAT DESC, ARNRTIM DESC                                                         MD029683
     C/end-exec

     C/exec sql
     C+ open NostroRecon
     C/end-exec

     C**********         Z-ADD     8             WSFPG                                      MD029683
     C                   Z-ADD     4             WSFPG                                      MD029683

      ** Set to *CHANGE mode

     C**********         EVAL      W1PMD = 'CHG'                                            MD023629

      ** Initialise subfile control

     C                   EVAL      SPOSN = *BLANKS
     C                   EVAL      #1RUNA = BJMRDT
     C                   EVAL      #1PGMQ = PSProcName
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1USER = PSUser

      ***Initialise subfile control                                                         MD023629
      **********                                                                            MD023629
     C**********         MOVEL     *BLANK        #1POS1                                     MD023629
     C**********         MOVEL     *BLANK        #1POS2                                     MD023629
     C**********         MOVEL     *BLANK        #1POS3                                     MD023629
     C**********         MOVEL     *BLANK        #1POS4                                     MD023629
     C**********         MOVEL     *BLANK        #1POS5                                     MD023629
      *                                                                                     MD023629
      ***Setup*key*to*access*IGACMETD**********************************            MD023629 MD029739
      ** Setup key to access DIACMETD                                                       MD029739
      *                                                                                     MD023629
     C                   CALL      'ZDATE2'                                                 MD023629
     C                   PARM      BJRDNB        PZDayNo                                    MD023629
      ** Force the date in format DDMMYY for convertion to YYMMDD                           MD023629
     C                   PARM      'D'           PBJDFIN                                    MD023629
     C                   PARM      *ZEROS        PZDate                                     MD023629
     C                   PARM      *BLANKS       PZADate                                    MD023629
     C                   MOVEL     PZDate        SELDAT                                     MD023629
     C                   MOVEL     SELYY         SELDY                                      MD023629
     C                   MOVEL     SELMM         SELDM                                      MD023629
     C                   MOVEL     SELDA         SELDD                                      MD023629

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************
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
      *****************************************************************
      /EJECT
      *****************************************************************
     P*****************************************************************
     P* pSQL_RanOK - See if last SQL statement ran ok.                *
     P*****************************************************************
     P pSQL_RanOk      b
     D pSQL_RanOk      pi              n
     D  iSQLState                     5a   Const

     C                   Return    %Subst(iSQLState:1:2) = '00'
     C                             or %Subst(iSQLState:1:2) = '01'

     P                 e
** CPY@
(c) Finastra International Limited 2013
** RECONSTAT
ARINIT
ARPROC
ARFAIL
JRBCHA
JRBCHH
RTPOST
RTPOSF
UMT940
COMPLT
EXTINI                                                                                 MD023629
EXTPRC                                                                                 MD023629
EXTCMP                                                                                 MD023629
CMPNJB                                                                                 MD029683
** RECONDESC
AR Initiated
AR Processing
AR Failed
Journal Batch Accepted
Journal Batch Held
Real Time Post
Real Time Post Failed
MT940 Production                                                                       MD029683
Complete
Export Batch initiated                                                                 MD023629
Export Batch in Process                                                                MD023629
Export Batch Completed                                                                 MD023629
Complete - No Journal Batch                                                            MD029683
