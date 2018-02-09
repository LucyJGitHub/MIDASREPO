     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Initialisation program for feature CSE022')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD00022   - Initialisation Program for Feature CSE022        *
      *                                                               *
      *  Function:  This module will copy BFDRF1 - BFDRF0 to the      *
      *             corresponding BFNDR1 - BFNDR0 in SDSECSPD and     *
      *             C101 - C110 to the corresponding C201 - C210 in   *
      *             CLINTSE. This will also change classifications    *
      *             'K' (Kassenverein) to 'X'.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 210519             Date 15Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022  *CREATE    Date 29Mar01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  210519 - Remove leading blank in BFDRF                       *
      *  CSE022 - Depository Definition Enhancement                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Error in file SDSECSPD                          *
      *    02         End of File in SDSECSPD                         *
      *    03         Error in file CLINTSE                           *
      *    04         End of File in CLINTSE                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRSDSECSPD - Process file SDSECSPD                            *
      * SRCLINTSE  - Process file CLINTSE                             *
      * SRAUDIT    - Write Audit Report                               *
      * *INZSR     - Initialise                                       *
      * *PSSR      - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Securities Clients
     FSDSECSPD  UF   E             DISK    INFSR(*PSSR)
 
      ** Midas SE Customer Security Details
     FCLINTSE   UF   E             DISK    INFSR(*PSSR)
 
      ** Initialisation Program printer file - Audit
     FSD00022P1 O    E             PRINTER INFSR(*PSSR)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
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
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
 
      /COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Depot References in file SDSECSPD Data Structure
     D DSDepRef1       DS
     D   BFDRF1
     D   BFDRF2
     D   BFDRF3
     D   BFDRF4
     D   BFDRF5
     D   BFDRF6
     D   BFDRF7
     D   BFDRF8
     D   BFDRF9
     D   BFDRF0
 
      ** Depot References in file CLINTSE Data Structure
     D DSDepRef2       DS
     D   C101
     D   C102
     D   C103
     D   C104
     D   C105
     D   C106
     D   C107
     D   C108
     D   C109
     D   C110
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl1            01     01
     D  EndOfFile1            02     02
     D  ErrorOnFl2            03     03
     D  EndOfFile2            04     04
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Process all records in file SDSECSPD
 
     C                   EXSR      SRSDSECSPD
 
      ** Process all records in file CLINTSE
 
     C                   EXSR      SRCLINTSE
 
      ** Print Details
 
     C                   EXSR      SRAUDIT
 
      ** Return to calling program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSDSECSPD - Process file SDSECSPD                           *
      *                                                               *
      *****************************************************************
 
     C     SRSDSECSPD    BEGSR
 
      ** Read all records from SDSECSPD
 
     C                   READ      SDSECSPD                             0102
 
      ** Database error
 
     C                   IF        ErrorOnFl1 = True
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm = 'SD00022P'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDSECSPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EXSR      SRAUDIT
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   DOW       EndOfFile1 = False
 
     C                   ADD       1             RREAD1
 
     C                   IF        DSDepRef1 <> *Blanks OR
     C                             BFCLAS = 'K'
 
      ** Copy old depot reference fields to new depot reference fields
 
     C                   IF        DSDepRef1 <> *Blanks
 
     C     1             subst     bfdrf1:1      wk1               1                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     bfdrf1        andne     *blank                                                     210519
     C     ' '           check     bfdrf1        c                 1 0                        210519
     C                   subst     bfdrf1:c      wk5               5                          210519
     C                   movel     wk5           bfndr1                                       210519
     C                   else                                                                 210519
     C                   EVAL      BFNDR1 = BFDRF1
     C                   end                                                                  210519
     C     1             subst     bfdrf2:1      wk1                                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     bfdrf2        andne     *blank                                                     210519
     C     ' '           check     bfdrf2        c                                            210519
     C                   subst     bfdrf2:c      wk5                                          210519
     C                   movel     wk5           bfndr2                                       210519
     C                   else                                                                 210519
     C                   EVAL      BFNDR2 = BFDRF2
     C                   end                                                                  210519
     C     1             subst     bfdrf3:1      wk1                                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     bfdrf3        andne     *blank                                                     210519
     C     ' '           check     bfdrf3        c                                            210519
     C                   subst     bfdrf3:c      wk5                                          210519
     C                   movel     wk5           bfndr3                                       210519
     C                   else                                                                 210519
     C                   EVAL      BFNDR3 = BFDRF3
     C                   end                                                                  210519
     C     1             subst     bfdrf4:1      wk1                                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     bfdrf4        andne     *blank                                                     210519
     C     ' '           check     bfdrf4        c                                            210519
     C                   subst     bfdrf4:c      wk5                                          210519
     C                   movel     wk5           bfndr4                                       210519
     C                   else                                                                 210519
     C                   EVAL      BFNDR4 = BFDRF4
     C                   end                                                                  210519
     C     1             subst     bfdrf5:1      wk1                                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     bfdrf5        andne     *blank                                                     210519
     C     ' '           check     bfdrf5        c                                            210519
     C                   subst     bfdrf5:c      wk5                                          210519
     C                   movel     wk5           bfndr5                                       210519
     C                   else                                                                 210519
     C                   EVAL      BFNDR5 = BFDRF5
     C                   end                                                                  210519
     C     1             subst     bfdrf6:1      wk1                                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     bfdrf6        andne     *blank                                                     210519
     C     ' '           check     bfdrf6        c                                            210519
     C                   subst     bfdrf6:c      wk5                                          210519
     C                   movel     wk5           bfndr6                                       210519
     C                   else                                                                 210519
     C                   EVAL      BFNDR6 = BFDRF6
     C                   end                                                                  210519
     C     1             subst     bfdrf7:1      wk1                                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     bfdrf7        andne     *blank                                                     210519
     C     ' '           check     bfdrf7        c                                            210519
     C                   subst     bfdrf7:c      wk5                                          210519
     C                   movel     wk5           bfndr7                                       210519
     C                   else                                                                 210519
     C                   EVAL      BFNDR7 = BFDRF7
     C                   end                                                                  210519
     C     1             subst     bfdrf8:1      wk1                                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     bfdrf8        andne     *blank                                                     210519
     C     ' '           check     bfdrf8        c                                            210519
     C                   subst     bfdrf8:c      wk5                                          210519
     C                   movel     wk5           bfndr8                                       210519
     C                   else                                                                 210519
     C                   EVAL      BFNDR8 = BFDRF8
     C                   end                                                                  210519
     C     1             subst     bfdrf9:1      wk1                                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     bfdrf9        andne     *blank                                                     210519
     C     ' '           check     bfdrf9        c                                            210519
     C                   subst     bfdrf9:c      wk5                                          210519
     C                   movel     wk5           bfndr9                                       210519
     C                   else                                                                 210519
     C                   EVAL      BFNDR9 = BFDRF9
     C                   end                                                                  210519
     C     1             subst     bfdrf0:1      wk1                                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     bfdrf0        andne     *blank                                                     210519
     C     ' '           check     bfdrf0        c                                            210519
     C                   subst     bfdrf0:c      wk5                                          210519
     C                   movel     wk5           bfndr0                                       210519
     C                   else                                                                 210519
     C                   EVAL      BFNDR0 = BFDRF0
     C                   end                                                                  210519
 
      ** Blank out the old depot reference fields
 
     C                   EVAL      BFDRF1 = *Blanks
     C                   EVAL      BFDRF2 = *Blanks
     C                   EVAL      BFDRF3 = *Blanks
     C                   EVAL      BFDRF4 = *Blanks
     C                   EVAL      BFDRF5 = *Blanks
     C                   EVAL      BFDRF6 = *Blanks
     C                   EVAL      BFDRF7 = *Blanks
     C                   EVAL      BFDRF8 = *Blanks
     C                   EVAL      BFDRF9 = *Blanks
     C                   EVAL      BFDRF0 = *Blanks
 
     C                   ENDIF
 
      ** If classification is 'K' (Kassenverein), change it to 'X'
 
     C                   IF        BFCLAS = 'K'
 
     C                   EVAL      BFCLAS = 'X'
 
     C                   ENDIF
 
      ** Update the record in file SDSECSPD
 
     C                   UPDATE    SDSECSD0
 
     C                   ADD       1             RUPDATE1
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      SDSECSPD                             0102
 
     C                   IF        ErrorOnFl1 = True
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm = 'SD00022P'
     C                   EVAL      DBKey = '*NEXT'
     C                   EVAL      DBFile = 'SDSECSPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EXSR      SRAUDIT
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLINTSE - Process file CLINTSE                             *
      *                                                               *
      *****************************************************************
 
     C     SRCLINTSE     BEGSR
 
      ** Real all records from CLINTSE
 
     C                   READ      CLINTSE                              0304
 
      ** Database error
 
     C                   IF        ErrorOnFl2 = True
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm = 'SD00022P'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'CLINTSE'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EXSR      SRAUDIT
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   DOW       EndOfFile2 = False
 
     C                   ADD       1             RREAD2
 
     C                   IF        DSDepRef2 <> *Blanks OR
     C                             C1DI = 'K'
 
      ** Copy old depot reference fields to new depot reference fields
 
     C                   IF        DSDepRef2 <> *Blanks
 
     C     1             subst     c101:1        wk1               1                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     c101          andne     *blank                                                     210519
     C     ' '           check     c101          c                 1 0                        210519
     C                   subst     c101:c        wk5               5                          210519
     C                   movel     wk5           c201                                         210519
     C                   else                                                                 210519
     C                   EVAL      C201 = C101
     C                   end                                                                  210519
     C     1             subst     c102:1        wk1               1                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     c102          andne     *blank                                                     210519
     C     ' '           check     c102          c                 1 0                        210519
     C                   subst     c102:c        wk5               5                          210519
     C                   movel     wk5           c202                                         210519
     C                   else                                                                 210519
     C                   EVAL      C202 = C102
     C                   end                                                                  210519
     C     1             subst     c103:1        wk1               1                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     c103          andne     *blank                                                     210519
     C     ' '           check     c103          c                 1 0                        210519
     C                   subst     c103:c        wk5               5                          210519
     C                   movel     wk5           c203                                         210519
     C                   else                                                                 210519
     C                   EVAL      C203 = C103
     C                   end                                                                  210519
     C     1             subst     c104:1        wk1               1                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     c104          andne     *blank                                                     210519
     C     ' '           check     c104          c                 1 0                        210519
     C                   subst     c104:c        wk5               5                          210519
     C                   movel     wk5           c204                                         210519
     C                   else                                                                 210519
     C                   EVAL      C204 = C104
     C                   end                                                                  210519
     C     1             subst     c105:1        wk1               1                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     c105          andne     *blank                                                     210519
     C     ' '           check     c105          c                 1 0                        210519
     C                   subst     c105:c        wk5               5                          210519
     C                   movel     wk5           c205                                         210519
     C                   else                                                                 210519
     C                   EVAL      C205 = C105
     C                   end                                                                  210519
     C     1             subst     c106:1        wk1               1                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     c106          andne     *blank                                                     210519
     C     ' '           check     c106          c                 1 0                        210519
     C                   subst     c106:c        wk5               5                          210519
     C                   movel     wk5           c206                                         210519
     C                   else                                                                 210519
     C                   EVAL      C206 = C106
     C                   end                                                                  210519
     C     1             subst     c107:1        wk1               1                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     c107          andne     *blank                                                     210519
     C     ' '           check     c107          c                 1 0                        210519
     C                   subst     c107:c        wk5               5                          210519
     C                   movel     wk5           c207                                         210519
     C                   else                                                                 210519
     C                   EVAL      C207 = C107
     C                   end                                                                  210519
     C     1             subst     c108:1        wk1               1                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     c108          andne     *blank                                                     210519
     C     ' '           check     c108          c                 1 0                        210519
     C                   subst     c108:c        wk5               5                          210519
     C                   movel     wk5           c208                                         210519
     C                   else                                                                 210519
     C                   EVAL      C208 = C108
     C                   end                                                                  210519
     C     1             subst     c109:1        wk1               1                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     c109          andne     *blank                                                     210519
     C     ' '           check     c109          c                 1 0                        210519
     C                   subst     c109:c        wk5               5                          210519
     C                   movel     wk5           c209                                         210519
     C                   else                                                                 210519
     C                   EVAL      C209 = C109
     C                   end                                                                  210519
     C     1             subst     c110:1        wk1               1                          210519
     C     wk1           ifeq      *blank                                                     210519
     C     c110          andne     *blank                                                     210519
     C     ' '           check     c110          c                 1 0                        210519
     C                   subst     c110:c        wk5               5                          210519
     C                   movel     wk5           c210                                         210519
     C                   else                                                                 210519
     C                   EVAL      C210 = C110
     C                   end                                                                  210519
 
      ** Blank out the old depot reference fields
 
     C                   EVAL      C101 = *Blanks
     C                   EVAL      C102 = *Blanks
     C                   EVAL      C103 = *Blanks
     C                   EVAL      C104 = *Blanks
     C                   EVAL      C105 = *Blanks
     C                   EVAL      C106 = *Blanks
     C                   EVAL      C107 = *Blanks
     C                   EVAL      C108 = *Blanks
     C                   EVAL      C109 = *Blanks
     C                   EVAL      C110 = *Blanks
 
     C                   ENDIF
 
      ** If classification is 'K' (Kassenverein), change it to 'X'
 
     C                   IF        C1DI = 'K'
 
     C                   EVAL      C1DI = 'X'
 
     C                   ENDIF
 
      ** Update the record in file CLINTSE
 
     C                   UPDATE    CLINTSEF
 
     C                   ADD       1             RUPDATE2
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      CLINTSE                              0304
 
     C                   IF        ErrorOnFl2 = True
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm = 'SD00022P'
     C                   EVAL      DBKey = '*NEXT'
     C                   EVAL      DBFile = 'CLINTSE'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EXSR      SRAUDIT
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Write Audit Report                                 *
      *                                                               *
      *****************************************************************
 
     C     SRAUDIT       BEGSR
 
     C                   OPEN      SD00022P1
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON
 
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** If there is a record read in SDSECSPD, write audit control report
 
     C                   IF        RREAD1 <> 0
 
     C                   WRITE     CONTROL1
 
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message
 
     C                   WRITE     NODTLS1
 
     C                   ENDIF
 
      ** If there is a record read in CLINTSE, write audit control report
 
     C                   IF        RREAD2 <> 0
 
     C                   WRITE     CONTROL2
 
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message
 
     C                   WRITE     NODTLS2
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CLOSE     SD00022P1
 
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
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *Blanks
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm = 'SD00022P'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EXSR      SRAUDIT
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
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
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
