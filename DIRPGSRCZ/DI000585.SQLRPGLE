     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Accounting Rules Monitor Check')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GL000585*-*Midas*OF*Accounting*Rules*Monitor*Check************                     MD029739
      *  DI000585 - Midas OF Accounting Rules Monitor Check           *                     MD029739
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD029739 *RENAMED* Date 15Aug14               *
      *                 MD029683           Date 19Aug14               *
      *                 MD025967           Date 24Apr14               *
      *                 MD024878           Date 20Feb14               *
      *                 MD025013           Date 13Feb14               *
      *                 MD023629           Date 08Jan14               *
      *                 MD023889           Date 10Dec13               *
      *                 MD023989           Date 05Dec13               *
      *                 MD023711A          Date 25Nov13               *
      *                 MD023711           Date 21Nov13               *
      *                 MD023628           Date 06Nov13               *
      *                 CGL135B  *Create   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD029739 - File renaming for integration layer.              *
      *  MD029683 - All Nostro transactions subject to reconciliation *
      *             should be written to Accounting Rules Nostro      *
      *             Reconcilation table (GLARNRTD).                   *
      *  MD025967  - Produce a report of the Updates/Writes of the    *
      *              Forecasts from the Accounting Rules.             *
      *  MD024878 - Only process specific Batch for forecast creation *
      *  MD025013 - Setup changes for Missing Acc Rules (Acc Code,    *
      *             Narrative, Front Office Id setup)                 *
      *  MD023629 - Accounting Rules Processing - Restart             *
      *  MD023889 - Accounting Rules Process (GL Account Creation)    *
      *  MD023989  - Invalid Status                                   *
      *  MD023711A - Timestamp format change                          *
      *  MD023711 - Data definition issues                            *
      *  MD023628 - Accounting Rules Process - restart processing     *
      *  CGL135B  - Accounting Rules Process                          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Nostro Details                                                    MD023628
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                               MD023628

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     ** File DS
     **   Midas GL Accounting Rules Monitor File
     D*DSACMNTD*     E DS                  EXTNAME(GLACMNTD)                                MD029739
     D DSACMNTD      E DS                  EXTNAME(DIACMNTD)                                MD029739

     **   Midas GL Accounting Rules Sequence Holder
     D DSACSQTD      E DS                  EXTNAME(GLACSQTD)

     **   Midas OF Accounting Rules Process for Nostro Reconciliation                      MD023628
     D*DSARNRTD*     E DS                  EXTNAME(GLARNRTD)                      MD023628 MD029739
     D DSARNRTD      E DS                  EXTNAME(DIARNRTD)                               MD029739
                                                                                           MD029683
     **   Midas OF Accounting Rules Process for Nostro Reconciliation (Rejected)           MD029683
     D DSARNXTD      E DS                  EXTNAME(DIARNXTD)                               MD029683
     D                                     PREFIX(R_)                                      MD029683
                                                                                           MD029683
      **   Midas OF Meridian Intellimatch RAW data                                         MD023628
     D*DSACMETD*     E DS                  EXTNAME(IGACMETD)                      MD023628 MD029739
     D DSACMETD      E DS                  EXTNAME(DIACMETD)                               MD029739

      **   Midas OF MT940/941/942/950 Messages Requests - Extented detail                  MD023628
     D DSMR941D      E DS                  EXTNAME(GLMR941D)                               MD023628

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D @RTCD           S              7
     D @OPTN           S              7
     D @SARD           S              6

     D WSEQN           S              7  0
     D WRun            S              1

      ***Front*Office*Id*DS*(GLACMNTD)*********************************                     MD029739
      ** Front Office Id DS (DIACMNTD)                                                      MD029739
     D WHFRNT          DS            20
     D  WHFRNAR                1      2                                         AR
     D  WHFRNDT                3      8                                         Date
     D  WHFRNSQ                9     15                                         Sequence
     D**WHFRNLT               16     16                                         Letter
     D**WHFRNFL               17     20                                         Filler
     D  WHFRNFL               16     20                                         Filler

      ** Parameter list fields
     D PBTID           S             60                                         Batch Id
     D PARST           S             30                                         AR Status
     D PARRT           S             10                                         AR Return  MD023628
     D PMSGR           S                   LIKE(DSMR941D)                       Msg Req.   MD023628
     D PSEQN           S              7                                         Sequence
     D PZONE           S             10                                         Zone

      ** AR Status
     D*ArSTAT1****     C                   CONST('AR INITIATED')                           MD023629
     D*ArSTAT2****     C                   CONST('AR PROCESSING')                          MD023629
     D*ArSTAT3****     C                   CONST('Journal Entry Accepted')                 MD023629
     D ArSTAT1         C                   CONST('AR Initiated')                           MD023629
     D ArSTAT2         C                   CONST('AR Processing')                          MD023629
     D ArSTAT3         C                   CONST('Journal Batch Accepted')                 MD023629
     D*ArSTAT4****     C                   CONST('Real Time Post Succeeded')               MD023989
     D ArSTAT4         C                   CONST('Real Time Post')                         MD023989
     D ArSTAT5         C                   CONST('Journal Batch Held')                     MD023989
     D ArSTAT6         C                   CONST('Real Time Post Failed')                  MD023989
     D ArSTAT7         C                   CONST('Complete - No Journal Batch')             MD029683

     D LETR            S              1    DIM(26) CTDATA PERRCD(26)

     D CGL145          S              1                                         ForeCast   MD023628
     D CGL146          S              1                                         MT940 I/C CMD023628

     D WkRealTime      S              1A                                        Real Time PMD023628
     D WkProdMT9xx     S              1A                                        Produce MT9MD023628
     D WkOurAccNost    S             35A                                        Our AccountMD023628
     D WkAccPool       S              6A   INZ('%30001')                        AccPool    MD023628
     D WkTimeStamp     S               Z                                        Time Stamp MD023628
     D WkXFTMSP        S             26A                                        Time Stamp MD023711
      *
      * Access objects parameters                                                          MD023628
     D P@RTCD          S              7A                                        Return CodeMD023628
     D P@OPTN          S              7A                                        Option     MD023628
     D P@OP01          S             20A                                                   MD023628
     D P@VL01          S            200A                                                   MD023628
     D P@OP02          S             20A                                                   MD023628
     D P@VL02          S            200A                                                   MD023628
     D P@OP03          S             20A                                                   MD023628
     D P@VL03          S            200A                                                   MD023628
     D P@OP04          S             20A                                                   MD023628
     D P@VL04          S            200A                                                   MD023628
     D P@OP05          S             20A                                                   MD023628
     D P@VL05          S            200A                                                   MD023628
     D P@OP06          S             20A                                                   MD023628
     D P@VL06          S            200A                                                   MD023628
     D P@OP07          S             20A                                                   MD023628
     D P@VL07          S            200A                                                   MD023628
     D P@OP08          S             20A                                                   MD023628
     D P@VL08          S            200A                                                   MD023628
     D P@OP09          S             20A                                                   MD023628
     D P@VL09          S            200A                                                   MD023628
     D P@OP10          S             20A                                                   MD023628
     D P@VL10          S            200A                                                   MD023628
      *                                                                                    MD023628
     D                 DS                                                                  MD023628
     D P@DateIn                1      8  0                                                 MD023628
     D   P@YYYY                1      4  0                                                 MD023628
     D   P@MM                  5      6  0                                                 MD023628
     D   P@DD                  7      8  0                                                 MD023628

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      * Init Processing
     C                   EXSR      INIT

      * End Processing
     C                   EXSR      END

     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Initiation Subroutine to check if Batch ID already  *
      *           processed                                           *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Reset working fields and Data Structures                                          MD023628
      *                                                                                    MD023628
     C                   EVAL      PARRT      =  *Blanks                                   MD023628
     C                   RESET                   DSARNRTD                       Nostro Mn  MD023628
     C                   RESET                   DSACMNTD                       AR Monitor MD023628
     C                   RESET                   DSACMETD                       Holding    MD023628
     C                   RESET                   DSMR941D                       Msg Req    MD023628
      *                                                                                    MD023628
      ** Retrieve Nostro                                                                   MD023628
      *                                                                                    MD023628
     C                   EVAL      WkOurAccNost = %SUBST(PBTID:16:35)                      MD023628
      *                                                                                    MD023628
     C/EXEC SQL                                                                            MD023628
     C+                  select * into :SDNOST                                             MD023628
     C+                         from  SDNOSTPD                                             MD023628
     C+                         where A7OACN = :WkOurAccNost                               MD023628
     C/END-EXEC                                                                            MD023628
      *                                                                                    MD023628
     C                   IF        SQLCODE <> 0                                            MD023628
     C                             AND SQLCODE <> -000000811                                MD029683
     C                   RESET                   SDNOST                                    MD023628
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
      ** If batch comming from IntelliMatch                                                MD023628
      *                                                                                    MD023628
     C                   IF        %SUBST(PBTID:1:2) = 'IM' And                            MD023628
     C                             A7CYCD <> *blanks                                       MD023628
      *                                                                                    MD023628
      ** Retrieve Statement details in Meridian holding file                               MD023628
      *                                                                                    MD023628
     C/Exec SQL                                                                            MD023628
     C+                  Select * into :DSACMETD                                           MD023628
     C*+*********                 from IGACMETD                                   MD023628 MD029739
     C+                           from DIACMETD                                            MD029739
     C+                          where XFBTID =    :PBTID     and                          MD023628
     C+                                XFAPSD LIKE :WkAccPool                              MD023628
     C/End-Exec                                                                            MD023628
      *                                                                                    MD023628
     C                   IF        SQLCODE <> 0                                            MD023628
     C                             AND SQLCODE <> -000000811                                MD029683
     C                   RESET                   DSACMETD                                  MD023628
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
     C                   IF        A7CYCD <> *blanks                                       MD023628
      *                                                                                    MD023628
      ** Check if nostro is in the nostro for reconciliation                               MD023628
      *                                                                                    MD023628
     C/Exec SQL                                                                            MD023628
     C+                  Select * into :DSARNRTD                                           MD023628
     C*+**********                from GLARNRTD                                   MD023628 MD029739
     C+                           from DIARNRTD                                            MD029739
     C+                          where ARNRCCY = :A7CYCD and                               MD023628
     C+                                ARNRNCD = :A7NONB                                   MD023628
     C+                                and ARNBTID = :PBTID                                 MD029683
     C/End-Exec                                                                            MD023628
      *                                                                                    MD023628
      ** If not found, create it.                                                          MD023628
      ** Or, new batch Id, update it.                                                      MD023628
      *                                                                                    MD023628
     C**********         IF        SQLCODE <> 0                                    MD023628 MD029683
     C**********                   OR                                              MD023628 MD029683
     C**********                   SQLCODE =  0     AND                            MD023628 MD029683
     C**********                   ARNBTID <> PBTID                     Last Batch MD023628 MD029683
      ** Statement details                                                                 MD023628
     C                   MOVE      XFSTMT        ARNRLSN                        Last Bank SMD023628
     C                   MOVE      XFPGNM        ARNRLSS                        Last Bank SMD023628
     C                   EVAL      ARNRDAT = *Zeros                             Date Last IMD023628
     C                   EVAL      ARNRTIM = *Zeros                             Time Last IMD023628
      ** Convert timestamp from SQL server ISO8601 to *ISO                                 MD023711
     C******             EVAL      WkXFTMSP = %SUBST(XFTMSP:1:23) + '000'         MD023711 MD023711A
     C                   EVAL      WkXFTMSP = %SUBST(XFTMSP:1:19) + '.000000'              MD023711A
     C                   EVAL      %SUBST(WkXFTMSP:11:1) = '-'                             MD023711
     C                   EVAL      %SUBST(WkXFTMSP:14:1) = '.'                             MD023711
     C                   EVAL      %SUBST(WkXFTMSP:17:1) = '.'                             MD023711
     C     *ISO          TEST(Z)                 WkXFTMSP               99                 MD023711
     C**********         IF        XFTMSP <> *Blanks                              MD023628 MD023711
     C******ISO*         MOVE      XFTMSP        WkTimeStamp                      MD023628 MD023711
     C  N99*ISO          MOVE      WkXFTMSP      WkTimeStamp                               MD023711
     C   99              TIME                    WkTimeStamp                               MD023711
     C                   EVAL      P@YYYY = %SUBDT(WkTimeStamp:*YEARS)                     MD023628
     C                   EVAL      P@MM   = %SUBDT(WkTimeStamp:*MONTHS)                    MD023628
     C                   EVAL      P@DD   = %SUBDT(WkTimeStamp:*DAYS)                      MD023628
     C                   CALL      'ZDATE10'                            99                 MD023628
     C                   PARM                    P@DateIn                                  MD023628
     C     ARNRDAT       PARM      *Zeros        P@DateOut         5 0          Date Last  MD023628
     C   99              EVAL      ARNRDAT = *Zeros                             Date Last IMD023628
     C                   EVAL      ARNRTIM =                                    Time Last IMD023628
     C                               (%SUBDT(WkTimeStamp:*HOURS) * 10000)                  MD023628
     C                             + (%SUBDT(WkTimeStamp:*MINUTES) * 100)                  MD023628
     C                             + (%SUBDT(WkTimeStamp:*SECONDS))                        MD023628
     C**********         ENDIF                                                    MD023628 MD023711
      ** Status                                                                            MD023711
     C                   EVAL      ARNRSTS = ArSTAT1                            Status     MD023628
     C                   EVAL      ARNRERC = *Blanks                            Error Code MD023628
      ** Midas Account                                                                     MD023628
     C                   EVAL      ARNOACN = A7OACN                             Our AccountMD023628
     C                   EVAL      ARNBRCA = A7BRCD                             Account BraMD023628
     C                   EVAL      ARNCNUM = A7CUST                             Account CusMD023628
     C                   MOVE      A7ACCD        ARNACCD                        Account CodMD023628
     C                   EVAL      ARNACSQ = A7ACSN                             Account SeqMD023628
      ** Last Batch Id                                                                     MD023628
     C                   EVAL      ARNBTID = PBTID                              Last Batch MD023628
      ** MT940/MT950 request                                                               MD023628
     C                   EVAL      ARNNWRK = *Blanks                            Network    MD023628
     C                   EVAL      ARNNATY = *Blanks                            Network AccMD023628
     C                   EVAL      ARNDSTN = *Blanks                            MT940 DestiMD023628
     C                   EVAL      ARNMTPY = *Blanks                            Message typMD023628
     C                   EVAL      ARNSORQ = *Blanks                            Source of rMD023628
     C                   EVAL      ARNSDTE = *Zeros                             Schedule StMD023628
     C                   EVAL      ARNSTIM = *Zeros                             Schedule StMD023628
     C                   EVAL      ARNRDTE = *Zeros                             Request DatMD023628
     C                   EVAL      ARNSRTIM= *Blanks                            Request TimMD023628
      ** Zone                                                                              MD023628
     C**********         EVAL      ARNZONE = BJZONE                             ZMD023628  MD023711
     C                   EVAL      ARNZONE = PZONE                              Zone       MD023711
      *                                                                                    MD023628
     C                   IF        SQLCODE <> 0                                            MD023628
      *                                                                                    MD023628
      ** Check if Batch ID exist in the rejected file                                       MD029683
      *                                                                                     MD029683
     C/Exec SQL                                                                             MD029683
     C+                  Select * into :DSARNXTD                                            MD029683
     C+                           from DIARNXTD                                             MD029683
     C+                          where ARNRCCY = :A7CYCD and                                MD029683
     C+                                ARNRNCD = :A7NONB                                    MD029683
     C+                                and ARNBTID = :PBTID                                 MD029683
     C/End-Exec                                                                             MD029683
      *                                                                                     MD029683
     C                   IF        SQLCODE <> 0                                             MD029683
      *                                                                                     MD029683
     C                   EVAL      ARNRCCY = A7CYCD                             Nostro CurrMD023628
     C                   EVAL      ARNRNCD = A7NONB                             Nostro CodeMD023628
      *                                                                                    MD023628
     C/exec SQL                                                                            MD023628
     C*+insert*into GLARNRTD                                                      MD023628 MD029739
     C+ insert into DIARNRTD                                                               MD029739
     C+ values(:DSARNRTD)                                                                  MD023628
     C/end-exec                                                                            MD023628
      *                                                                                    MD023628
     C                   ENDIF                                                              MD029683
      *                                                                                     MD029683
     C                   ELSE                                                              MD023628
      *                                                                                    MD023628
     C/exec SQL                                                                            MD023628
     C*+Update*GLARNRTD                                                           MD023628 MD029739
     C+ Update DIARNRTD                                                                    MD029739
     C+   Set ARNRLSN  = :ARNRLSN,                                                         MD023628
     C+       ARNRLSS  = :ARNRLSS,                                                         MD023628
     C**********+       ARNRDAT  = :ARNRDAT,                                       MD023628 MD029683
     C**********+       ARNRTIM  = :ARNRTIM,                                       MD023628 MD029683
     C+       ARNRSTS  = :ARNRSTS,                                                         MD023628
     C+       ARNRERC  = :ARNRERC,                                                         MD023628
     C+       ARNOACN  = :ARNOACN,                                                         MD023628
     C+       ARNBRCA  = :ARNBRCA,                                                         MD023628
     C+       ARNCNUM  = :ARNCNUM,                                                         MD023628
     C+       ARNACCD  = :ARNACCD,                                                         MD023628
     C+       ARNACSQ  = :ARNACSQ,                                                         MD023628
     C+       ARNBTID  = :ARNBTID,                                                         MD023628
     C+       ARNNWRK  = :ARNNWRK,                                                         MD023628
     C+       ARNNATY  = :ARNNATY,                                                         MD023628
     C+       ARNDSTN  = :ARNDSTN,                                                         MD023628
     C+       ARNMTPY  = :ARNMTPY,                                                         MD023628
     C+       ARNSORQ  = :ARNSORQ,                                                         MD023628
     C+       ARNSDTE  = :ARNSDTE,                                                         MD023628
     C+       ARNSTIM  = :ARNSTIM,                                                         MD023628
     C+       ARNRDTE  = :ARNRDTE,                                                         MD023628
     C+       ARNSRTIM = :ARNSRTIM,                                                        MD023628
     C+       ARNZONE  = :ARNZONE                                                          MD023628
     C+   where ARNRCCY = :A7CYCD and                                                      MD023628
     C+         ARNRNCD = :A7NONB                                                          MD023628
     C+         and ARNBTID = :PBTID                                                        MD029683
     C/end-exec                                                                            MD023628
      *                                                                                    MD023628
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
     C**********         ENDIF                                                     MD023628 MD029683
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
      ** Check if Batch ID already processed
     C/Exec SQL
     C+                  Select * into :DSACMNTD
     C*+********                  from GLACMNTD                                             MD029739
     C+                           from DIACMNTD                                             MD029739
     C+                          where MNBTID = :PBTID
     C/End-Exec
      ** If not found
      ***** Write record to Monitor file
      ***** Initiate processing from start
     C                   If        SQLCOD <> 0
     C                   EXSR      WRITEMN
     C                   EXSR      PROFUL
      *
     C                   Else
      ** If found and AR Status = 'AR Initiated'
      ***** Initiate processing from start
     C                   If        SQLCOD = 0 AND
     C                             MNARST = ArSTAT1
     C                   EVAL      PARST = MNARST
     C                   EVAL      PSEQN = %SUBST(MNFRNT:9:7)                               MD029683
     C                   EXSR      PROFUL
      *
      ** If found and AR Status = 'Complete - No Journal Batch'                             MD029683
      ***** Initiate processing from start                                                  MD029683
     C                   ELSEIF    SQLCOD = 0 AND                                           MD029683
     C                             MNARST = ArSTAT7                                         MD029683
     C                   EVAL      PARST = ArSTAT1                                          MD029683
     C                   EVAL      PSEQN = %SUBST(MNFRNT:9:7)                               MD029683
     C                   EXSR      PROFUL                                                   MD029683
      *                                                                                     MD029683
     C                   Else
      ** If found
      ***** Process based on AR Status
     C                   If        SQLCOD = 0
     C                   EVAL      PARST = MNARST
     C                   EXSR      PROPRT
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PROFUL - Process Batch Id details from beginning             *
      *                                                               *
      *****************************************************************
     C     PROFUL        BEGSR
      *
     C                   CALL      'GLC000586'
     C                   PARM                    PBTID
     C                   PARM                    PARST
     C                   PARM                    PSEQN
     C                   PARM                    PZONE
      *
      **  Update Monitor files                                                             MD023629
      *                                                                                    MD023629
     C                   EVAL      PARRT = *Blanks                                         MD023629
     C                   EXSR      UPDATEMN                                                MD023629
      *
      ** If AR Status = 'AR Processing'
     C                   If        PARST = ArSTAT2
      *
      ****Create*GL*Accounts*if*required*************
     C**********         CALL      'GL000594J'                                             MD023889
     C**********         PARM                    PBTID                                     MD023889
      *                                                                                    MD023889
      **  Update Actual Amounts against Forecast (CGL145)                                  MD023628
     C                   IF        CGL145 = 'Y'                                            MD023628
     C**********         CALL      'GL009562'                                     MD023628 MD025967
     C                   CALL      'GLC009562'                                             MD025967
     C                   PARM                    PBTID                                     MD024878
     C                   PARM      'A'           PMODE             1                       MD025967
     C                   PARM      '    '        PSEQ              5                       MD025967
     C                   PARM      'B'           PLEV              1                       MD025967
     C                   PARM      'ALL'         PENT              3                       MD025967
     C                   ENDIF                                                             MD023628
      *
      **  Insert postings
     C**********         CALL      'GL000587'                                               MD029739
     C                   CALL      'DI000587'                                               MD029739
     C                   PARM                    PBTID
     C                   PARM                    PARST
     C                   PARM      *Blanks       PARRT                                     MD023628
      *                                                                                    MD023628
      **  Update Monitor files                                                             MD023628
     C                   EXSR      UPDATEMN                                                MD023628
      *                                                                                    MD023628
     C                   Endif
      *
      ** If AR Status = 'Journal Bacth Accepted'
     C******             If        MNARST = ArSTAT3                                        MD023989
     C                   If        PARST  = ArSTAT3                                        MD023989
     C                             AND WkRealTime = 'Y'                                    MD023628
      *
      **  Insert real time postings
     C**********         CALL      'GL000588'                                               MD029739
     C                   CALL      'DI000588'                                               MD029739
     C                   PARM                    PBTID
     C                   PARM                    PARST
     C                   PARM      *Blanks       PARRT                                     MD023628
      *                                                                                    MD023628
      **  Update Monitor files                                                             MD023628
     C                   EXSR      UPDATEMN                                                MD023628
      *                                                                                    MD023628
     C                   Endif
      *
      ** If AR Status = 'Real Time Post Succeeded'
     C******             If        MNARST = ArSTAT4                                        MD023989
     C                   If        PARST  = ArSTAT4                                        MD023989
     C                             AND WkProdMT9xx = 'Y'                                   MD023628
      *
      **  Request IntelliMach MT940/MT950 statement
     C**********         CALL      'GL000589'                                               MD029739
     C                   CALL      'DI000589'                                               MD029739
     C                   PARM                    PBTID
     C                   PARM                    PARST
     C                   PARM      *Blanks       PARRT                                     MD023628
     C     DSMR941D      PARM      *Blanks       PMSGR                                     MD023628
      *                                                                                    MD023628
      **  Update Monitor files                                                             MD023628
     C                   EXSR      UPDATEMN2                                               MD023628
      *                                                                                    MD023628
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PROPRT - Process Batch Id starting from current AR Status    *
      *                                                               *
      *****************************************************************
     C     PROPRT        BEGSR
      *
      ** If AR Status = 'AR Processing'
     C                   If        PARST = ArSTAT2
      *  OR 'Journal Batch Held'                                                           MD023629
     C                             OR PARST = ArSTAT5                                      MD023629
      *
      ****Create*GL*Accounts*if*required************                                       MD023889
     C**********         CALL      'GL000594J'                                             MD023889
     C**********         PARM                    PBTID                                     MD023889
      *
      **  Update Actual Amounts against Forecast (CGL145)                                  MD023628
     C                   IF        CGL145 = 'Y'                                            MD023628
     C**********         CALL      'GL009562'                                     MD023628 MD025967
     C                   CALL      'GLC009562'                                             MD025967
     C                   PARM                    PBTID                                     MD024878
     C                   PARM      'A'           PMODE             1                       MD025967
     C                   PARM      '    '        PSEQ              5                       MD025967
     C                   PARM      'B'           PLEV              1                       MD025967
     C                   PARM      'ALL'         PENT              3                       MD025967
     C                   ENDIF                                                             MD023628
      *
      **  Insert postings
     C**********         CALL      'GL000587'                                               MD029739
     C                   CALL      'DI000587'                                               MD029739
     C                   PARM                    PBTID
     C                   PARM                    PARST
     C                   PARM      *Blanks       PARRT                                     MD023628
      *                                                                                    MD023628
      **  Update Monitor files                                                             MD023628
     C                   EXSR      UPDATEMN                                                MD023628
      *                                                                                    MD023628
     C                   Endif
      *
      ** If AR Status = 'Journal Bacth Accepted'
     C                   If        PARST = ArSTAT3
     C                             AND WkRealTime = 'Y'                                    MD023628
      ** OR AR Status = 'Real Time Post Failed                                             MD023629
     C                             OR PARST = ArSTAT6                                      MD023629
     C                             AND WkRealTime = 'Y'                                    MD023629
      *
      **  Insert real time postings
     C**********         CALL      'GL000588'                                               MD029739
     C                   CALL      'DI000588'                                               MD029739
     C                   PARM                    PBTID
     C                   PARM                    PARST
     C                   PARM      *Blanks       PARRT                                     MD023628
      *                                                                                    MD023628
      **  Update Monitor files                                                             MD023628
     C                   EXSR      UPDATEMN                                                MD023628
      *                                                                                    MD023628
     C                   Endif
      *
      ** If AR Status = 'Real Time Post Succeeded'
     C                   If        PARST = ArSTAT4
     C                             AND WkProdMT9xx = 'Y'                                   MD023628
      *
      **  Request IntelliMach MT940/MT950 statement
     C**********         CALL      'GL000589'                                               MD029739
     C                   CALL      'DI000589'                                               MD029739
     C                   PARM                    PBTID
     C                   PARM                    PARST
     C                   PARM      *Blanks       PARRT                                     MD023628
     C     DSMR941D      PARM      *Blanks       PMSGR                                     MD023628
      *                                                                                    MD023628
      **  Update Monitor files                                                             MD023628
     C                   EXSR      UPDATEMN2                                               MD023628
      *                                                                                    MD023628
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WRITEMN - Write record to Monitor File                       *
      *                                                               *
      *****************************************************************
     C     WRITEMN       BEGSR
      *
      ** Batch Id
     C                   EVAL      MNBTID = PBTID
      ** Front Office Id
     C                   MOVEL     'AR'          WHFRNAR
     C                   EVAL      DAYNO = BJRDNB
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         WHFRNDT
      ** Retrieve sequence for Front Id
     C                   EXSR      SEQRTV
     C*******************MOVEL     *BLANKS       WHFRNFL                        MD025013
     C                   MOVEL     'A    '       WHFRNFL                        MD025013
     C                   MOVEL     WHFRNT        MNFRNT
      *
      ** Date
     C                   EVAL      MNRNDN = BJRDNB
      ** AR Status
     C                   EVAL      MNARST = ArSTAT1
      ** Zone
     C**********         EVAL      MNZONE = BJZONE                                         MD023711
     C                   EVAL      MNZONE = PZONE                                          MD023711
      ** Account details                                                                   MD023628
     C                   IF        A7CYCD <> *blanks                                       MD023628
     C                   EVAL      MNOACN = A7OACN                              Our AccountMD023628
     C                   EVAL      MNBRCA = A7BRCD                              Account BraMD023628
     C                   EVAL      MNCNUM = A7CUST                              Account CusMD023628
     C                   EVAL      MNRCCY = A7CYCD                              Nostro CurrMD023628
     C                   MOVE      A7ACCD        MNACCD                         Account CodMD023628
     C                   EVAL      MNACSQ = A7ACSN                              Account SeqMD023628
     C                   ELSE                                                              MD023711
     C                   EVAL      MNOACN = *Blanks                             Our Accou  MD023711
     C                   EVAL      MNBRCA = *Blanks                             Account B  MD023711
     C                   EVAL      MNCNUM = *Blanks                             Account C  MD023711
     C                   EVAL      MNRCCY = *Blanks                             Nostro Cu  MD023711
     C                   EVAL      MNACCD = *Zeros                              Account C  MD023711
     C                   EVAL      MNACSQ = *Zeros                              Account S  MD023711
     C                   EVAL      MNACSQ = *Zeros                              Account S  MD023711
     C                   ENDIF                                                             MD023628
      ** MT940/MT950 request                                                               MD023711
     C                   EVAL      MNNWRK = *Blanks                             Network    MD023711
     C                   EVAL      MNNATY = *Blanks                             Network A  MD023711
     C                   EVAL      MNDSTN = *Blanks                             MT940 Des  MD023711
     C                   EVAL      MNMTPY = *Blanks                             Message t  MD023711
     C                   EVAL      MNSORQ = *Blanks                             Source of  MD023711
     C                   EVAL      MNSDTE = *Zeros                              Schedule   MD023711
     C                   EVAL      MNSTIM = *Zeros                              Schedule   MD023711
     C                   EVAL      MNRDTE = *Zeros                              Request D  MD023711
     C                   EVAL      MNSRTIM= *Blanks                             Request T  MD023711
      *
     C/exec SQL
     C*+insert*into GLACMNTD                                                                MD029739
     C+ insert into DIACMNTD                                                                MD029739
     C+ values(:DSACMNTD)
     C/end-exec
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                    MD023628
      *                                                               *                    MD023628
      *  UPDATEMN - Update Status in Monitor Files                    *                    MD023628
      *                                                               *                    MD023628
      *****************************************************************                    MD023628
     C     UPDATEMN      BEGSR                                                             MD023628
      *                                                                                    MD023628
      ** Update the Accounting Rule Monitor file                                           MD023628
      *                                                                                    MD023628
     C/exec SQL                                                                            MD023628
     C*+update*GLACMNTD                                                           MD023628 MD029739
     C+ update DIACMNTD                                                                    MD029739
     C+   Set MNARST   = :PARST,                                                           MD023628
     C+       MNRERC   = :PARRT                                                            MD023628
     C+   where MNBTID = :PBTID                                                            MD023628
     C/end-exec                                                                            MD023628
      *                                                                                    MD023628
      ** Update the Accounting Rule Monitor file for reconciliation                        MD023628
      *                                                                                    MD023628
     C                   IF        A7CYCD <> *Blanks                                       MD023628
      *                                                                                    MD023628
     C/Exec SQL                                                                             MD029683
     C+                  Select * into :DSARNRTD                                            MD029683
     C*+********                  from GLARNRTD                                    MD029683 MD023628
     C+                           from DIARNRTD                                             MD023628
     C+                          where ARNRCCY = :A7CYCD and                                MD029683
     C+                                ARNRNCD = :A7NONB                                    MD029683
     C+                                and ARNBTID = :PBTID                                 MD029683
     C/End-Exec                                                                             MD029683
      *                                                                                     MD029683
     C                   IF        SQLCODE = 0                                              MD029683
      *                                                                                     MD029683
     C/exec SQL                                                                            MD023628
     C*+update*GLARNRTD                                                           MD023628 MD029739
     C+ update DIARNRTD                                                                    MD029739
     C+   Set ARNRSTS  = :PARST,                                                           MD023628
     C+       ARNRERC  = :PARRT                                                            MD023628
     C+   where ARNRCCY = :A7CYCD and                                                      MD023628
     C+         ARNRNCD = :A7NONB                                                          MD023628
     C+         and ARNBTID = :PBTID                                                        MD029683
     C/end-exec                                                                            MD023628
      *                                                                                    MD023628
     C                   ELSE                                                               MD029683
      *                                                                                     MD029683
     C/exec SQL                                                                             MD029683
     C+ update DIARNXTD                                                                     MD029683
     C+   Set ARNRSTS  = :PARST                                                             MD029683
     C+   where ARNRCCY = :A7CYCD and                                                       MD029683
     C+         ARNRNCD = :A7NONB                                                           MD029683
     C+         and ARNBTID = :PBTID                                                        MD029683
     C/end-exec                                                                             MD029683
      *                                                                                     MD029683
     C                   ENDIF                                                              MD029683
      *                                                                                     MD029683
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
     C                   ENDSR                                                             MD023628
      *****************************************************************                    MD023628
      /EJECT                                                                               MD023628
      *****************************************************************                    MD023628
      *                                                               *                    MD023628
      *  UPDATEMN2 - Update Status & MT940/MT950 request in Monitors  *                    MD023628
      *                                                               *                    MD023628
      *****************************************************************                    MD023628
     C     UPDATEMN2     BEGSR                                                             MD023628
      *                                                                                    MD023628
      ** Update the Accounting Rule Monitor file                                           MD023628
      *                                                                                    MD023628
     C/exec SQL                                                                            MD023628
     C*+update*GLACMNTD                                                           MD023628 MD029739
     C+ update DIACMNTD                                                                    MD029739
     C+   Set MNARST   = :PARST,                                                           MD023628
     C+       MNRERC   = :PARRT,                                                           MD023628
     C+       MNNWRK   = :M1NWRK,                                                          MD023628
     C+       MNNATY   = :M1NATY,                                                          MD023628
     C+       MNDSTN   = :M1DSTN,                                                          MD023628
     C+       MNMTPY   = :M1MTPY,                                                          MD023628
     C+       MNSORQ   = :M1SORQ,                                                          MD023628
     C+       MNSDTE   = :M1SDTE,                                                          MD023628
     C+       MNSTIM   = :M1STIM,                                                          MD023628
     C+       MNRDTE   = :M1RDTE,                                                          MD023628
     C+       MNSRTIM  = :M1SRTIM                                                          MD023628
     C+   where MNBTID = :PBTID                                                            MD023628
     C/end-exec                                                                            MD023628
      *                                                                                    MD023628
      ** Update the Accounting Rule Monitor file for reconciliation                        MD023628
      *                                                                                    MD023628
     C                   IF        A7CYCD <> *Blanks                                       MD023628
      *                                                                                     MD029683
     C/Exec SQL                                                                             MD029683
     C+                  Select * into :DSARNRTD                                            MD029683
     C*+********                  from GLARNRTD                                    MD029683 MD029739
     C+                           from DIARNRTD                                             MD029739
     C+                          where ARNRCCY = :A7CYCD and                                MD029683
     C+                                ARNRNCD = :A7NONB                                    MD029683
     C+                                and ARNBTID = :PBTID                                 MD029683
     C/End-Exec                                                                             MD029683
      *                                                                                     MD029683
     C                   IF        SQLCODE = 0                                              MD029683
      *                                                                                    MD023628
     C/exec SQL                                                                            MD023628
     C*+update*GLARNRTD                                                           MD023628 MD029739
     C+ update DIARNRTD                                                                    MD029739
     C+   Set ARNRSTS  = :PARST,                                                           MD023628
     C+       ARNRERC  = :PARRT,                                                           MD023628
     C+       ARNNWRK  = :M1NWRK,                                                          MD023628
     C+       ARNNATY  = :M1NATY,                                                          MD023628
     C+       ARNDSTN  = :M1DSTN,                                                          MD023628
     C+       ARNMTPY  = :M1MTPY,                                                          MD023628
     C+       ARNSORQ  = :M1SORQ,                                                          MD023628
     C+       ARNSDTE  = :M1SDTE,                                                          MD023628
     C+       ARNSTIM  = :M1STIM,                                                          MD023628
     C+       ARNRDTE  = :M1RDTE,                                                          MD023628
     C+       ARNSRTIM = :M1SRTIM                                                          MD023628
     C+   where ARNRCCY = :A7CYCD and                                                      MD023628
     C+         ARNRNCD = :A7NONB                                                          MD023628
     C+         and ARNBTID = :PBTID                                                        MD029683
     C/end-exec                                                                            MD023628
      *                                                                                    MD023628
     C                   ELSE                                                               MD029683
     C/exec SQL                                                                             MD029683
     C+ update DIARNXTD                                                                     MD029683
     C+   Set ARNRSTS  = :PARST,                                                            MD029683
     C+       ARNNWRK  = :M1NWRK,                                                           MD029683
     C+       ARNNATY  = :M1NATY,                                                           MD029683
     C+       ARNDSTN  = :M1DSTN,                                                           MD029683
     C+       ARNMTPY  = :M1MTPY,                                                           MD029683
     C+       ARNSORQ  = :M1SORQ,                                                           MD029683
     C+       ARNSDTE  = :M1SDTE,                                                           MD029683
     C+       ARNSTIM  = :M1STIM,                                                           MD029683
     C+       ARNRDTE  = :M1RDTE,                                                           MD029683
     C+       ARNSRTIM = :M1SRTIM                                                           MD029683
     C+   where ARNRCCY = :A7CYCD and                                                       MD029683
     C+         ARNRNCD = :A7NONB                                                           MD029683
     C+         and ARNBTID = :PBTID                                                        MD029683
     C/end-exec                                                                             MD029683
      *                                                                                     MD029683
     C                   ENDIF                                                              MD029683
      *                                                                                     MD029683
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
     C                   ENDSR                                                             MD023628
      *****************************************************************                    MD023628
      /EJECT
      *****************************************************************
      *                                                               *
      *  CVTDAT - Convert Date from Midas Day No. to DDMMYY           *
      *                                                               *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    DAYNO             5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM      *ZEROS        ZADATE            7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SEQRTV - Retrieve Sequence for Front Office ID               *
      *                                                               *
      *****************************************************************
     C     SEQRTV        BEGSR
      *
     C/Exec SQL
     C+ Declare ACSQDT scroll Cursor for
     C+                  Select * from GLACSQTD
     C+                          where SQZONE = :PZONE
     C/End-Exec
      *
     C/Exec SQL
     C+ Open ACSQDT
     C/End-Exec
      *
     C/Exec SQL
     C+ Fetch First
     C+   From ACSQDT
     C+   into :DSACSQTD
     C/End-Exec
b1   C                   If        SQLSTT = '00000'
     C                   MOVEL     SQSEQN        WSEQN
     C                   ADD       1             WSEQN
     C                   MOVEL     WSEQN         WHFRNSQ
     C                   MOVEL     WHFRNSQ       PSEQN
     C**********         MOVE      '1'           YANN              1                       MD023711
     C**********         DUMP                                                              MD023711
     C/EXEC SQL
     C+ UPDATE GLACSQTD SET SQSEQN = :WHFRNSQ
     C+ WHERE SQZONE = :PZONE
     C/END-EXEC
     C                   ELSE                                                              MD023711
     C                   Z-ADD     1             WSEQN                                     MD023711
     C                   MOVEL     WSEQN         WHFRNSQ                                   MD023711
     C                   MOVEL     WHFRNSQ       PSEQN                                     MD023711
     C/EXEC SQL                                                                            MD023711
     C+ INSERT INTO GLACSQTD                                                               MD023711
     C+ VALUES(:WHFRNSQ, :PZONE)                                                           MD023711
     C/END-EXEC                                                                            MD023711
     C                   Endif
      *
     C/Exec SQL
     C+ Close ACSQDT
     C/End-Exec
     C*****************  Z-ADD     1             X                 2 0
     C*****************  MOVEL     LETR(X)       WHFRNLT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PBTID
     C                   PARM                    PARST
     C                   PARM                    PZONE

      ** Set off program indicators
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

      ** Access Bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        @RTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = @OPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if CGL145 - Forecast is enabled                                             MD023628
      *                                                                                    MD023628
     C                   EVAL      CGL145 = 'N'                                            MD023628
      *                                                                                    MD023628
     C                   CALL      'AOSARDR0'                                              MD023628
     C                   PARM      *Blanks       @RTCD                                     MD023628
     C                   PARM      '*VERIFY'     @OPTN                                     MD023628
     C                   PARM      'CGL145'      @SARD                                     MD023628
     C                   PARM                    DSFDY                                     MD023628
      *                                                                                    MD023628
     C                   IF        @RTCD = *Blanks                                         MD023628
     C                   EVAL      CGL145 = 'Y'                                            MD023628
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
      ** Retrieve system values:                                                           MD023628
      ** - Rules Real Time Post Flag                                                       MD023628
      *                                                                                    MD023628
     C                   EVAL      P@OP01 = 'AcctRulesRealTimPost'                         MD023628
      *                                                                                    MD023628
     C                   CALL      'AOSVALR0'                                              MD023628
     C                   PARM      *Blanks       P@RTCD                                    MD023628
     C                   PARM                    P@OP01                                    MD023628
     C                   PARM      *Blanks       P@VL01                                    MD023628
     C                   PARM                    P@OP02                                    MD023628
     C                   PARM                    P@VL02                                    MD023628
     C                   PARM                    P@OP03                                    MD023628
     C                   PARM                    P@VL03                                    MD023628
     C                   PARM                    P@OP04                                    MD023628
     C                   PARM                    P@VL04                                    MD023628
     C                   PARM                    P@OP05                                    MD023628
     C                   PARM                    P@VL05                                    MD023628
     C                   PARM                    P@OP06                                    MD023628
     C                   PARM                    P@VL06                                    MD023628
     C                   PARM                    P@OP07                                    MD023628
     C                   PARM                    P@VL07                                    MD023628
     C                   PARM                    P@OP08                                    MD023628
     C                   PARM                    P@VL08                                    MD023628
     C                   PARM                    P@OP09                                    MD023628
     C                   PARM                    P@VL09                                    MD023628
     C                   PARM                    P@OP10                                    MD023628
     C                   PARM                    P@VL10                                    MD023628
      *                                                                                    MD023628
     C     P@RTCD        IFEQ      *Blanks                                                 MD023628
     C                   EVAL      WkRealTime  = P@VL01                                    MD023628
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
      ** Check if CGL146 - MT940/MT950 Production in Input Cycle                           MD023628
      *                                                                                    MD023628
     C                   EVAL      CGL146 = 'N'                                            MD023628
      *                                                                                    MD023628
     C                   CALL      'AOSARDR0'                                              MD023628
     C                   PARM      *Blanks       @RTCD                                     MD023628
     C                   PARM      '*VERIFY'     @OPTN                                     MD023628
     C                   PARM      'CGL146'      @SARD                                     MD023628
     C                   PARM                    DSFDY                                     MD023628
      *                                                                                    MD023628
     C                   IF        @RTCD = *Blanks                                         MD023628
     C                   EVAL      CGL146 = 'Y'                                            MD023628
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
     C                   IF        CGL146 = 'Y'                                            MD023628
      *                                                                                    MD023628
      ** Retrieve system values:                                                           MD023628
      ** - Produce MT940/MT950                                                             MD023628
      *                                                                                    MD023628
     C                   EVAL      P@OP01 = 'ProduceMT940'                                 MD023628
      *                                                                                    MD023628
     C                   CALL      'AOSVALR0'                                              MD023628
     C                   PARM      *Blanks       P@RTCD                                    MD023628
     C                   PARM                    P@OP01                                    MD023628
     C                   PARM      *Blanks       P@VL01                                    MD023628
     C                   PARM                    P@OP02                                    MD023628
     C                   PARM                    P@VL02                                    MD023628
     C                   PARM                    P@OP03                                    MD023628
     C                   PARM                    P@VL03                                    MD023628
     C                   PARM                    P@OP04                                    MD023628
     C                   PARM                    P@VL04                                    MD023628
     C                   PARM                    P@OP05                                    MD023628
     C                   PARM                    P@VL05                                    MD023628
     C                   PARM                    P@OP06                                    MD023628
     C                   PARM                    P@VL06                                    MD023628
     C                   PARM                    P@OP07                                    MD023628
     C                   PARM                    P@VL07                                    MD023628
     C                   PARM                    P@OP08                                    MD023628
     C                   PARM                    P@VL08                                    MD023628
     C                   PARM                    P@OP09                                    MD023628
     C                   PARM                    P@VL09                                    MD023628
     C                   PARM                    P@OP10                                    MD023628
     C                   PARM                    P@VL10                                    MD023628
      *                                                                                    MD023628
     C     P@RTCD        IFEQ      *Blanks                                                 MD023628
     C                   EVAL      WkProdMT9xx = P@VL01                                    MD023628
     C                   ENDIF                                                             MD023628
                                                                                           MD023628
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  END    - End program                                         *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     END           BEGSR

     C                   EVAL      *INLR = *On

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On

     C                   RETURN

     C                   ENDSR
      *****************************************************************
** LETR
ABCDEFGHIJKLMNOPQRSTUVWXYZ
