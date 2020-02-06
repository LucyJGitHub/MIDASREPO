     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Report on EODPOPD discrepancies')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP000008 - Report on EOPPOPD discrepancies                   *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27788 *CREATE   Date 25May10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27788 - Postings reconciliation utility                   *
      *                                                               *
      *****************************************************************
      *
     FUPPOSTPD  IF   E           K DISK    INFSR(*PSSR)
     FUP000008P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SpoolData)
     F                                     USROPN
      *
      /EJECT
     D PDate           S              7
     D PFmLib          S             10
     D PToLib          S             10
     D PostTotal       S             20
     D PostNumber      S              8
     D StoreCHQN       S              6  0
     D RqdLines        S              1  0 INZ(3)
     D RemainLn        S              2  0
     D SaveSPOS        S              7
     D Heading         S             43    INZ('Posting Reconciliation for +
     D                                     Run Date')
     D NotFound        S             69    INZ('Postings for this account / +
     D                                     source combination not found in')
     D Recursive       S              1    INZ(' ')
      *
     D                 DS
     D Account                 1     28
     D  Branch                 1      3
     D                         4      4    INZ('-')
     D  Customer               5     10
     D                        11     11    INZ('-')
     D  Currency              12     14
     D                        15     15    INZ('-')
     D  AccountCodeA          16     25
     D  AccountCodeN          16     25  0
     D                        26     26    INZ('-')
     D  SequenceA             27     28
     D  SequenceN             27     28  0
      *
     D SpoolData       DS
     D  SpoolFile             83     92
     D  SpoolFileNo          123    124B 0
     D  OverFlowLn           188    189B 0
     D  PrintLn              367    368B 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    PDate
     C                   PARM                    PFmLib
     C                   PARM                    PToLib
      *
     C                   EVAL      S08MTX = %TRIMR(Heading) + ' ' + PDate
      * Open printer file.
     C                   OPEN      UP000008P1
     C                   WRITE     MAINH
      *
     C     *LOVAL        SETLL     UPPOSTPD
     C                   READ      UPPOSTPD
      * If no records are found then write 'No records' and end.
     C                   IF        %EOF
     C                   WRITE     NORECS
     C                   CLOSE     UP000008P1
     C                   ELSE
      *
     C                   DOU       %EOF
      * Set up standard values for detail line.
     C                   IF        SaveSPOS <> SPOS
     C                   EVAL      SaveSPOS =  SPOS
     C                   EVAL      S08SRC = SPOS
     C                   ELSE
     C                   EVAL      S08SRC = *blanks
     C                   ENDIF
     C                   EVAL      Branch = BRCA
     C                   EVAL      Customer = CNUM
     C                   EVAL      Currency = CCY
     C                   EVAL      AccountCodeN = ACOD
     C                   EVAL      SequenceN = ACSQ
     C                   EVAL      S08ACC = Account
      * If record is for for postings total or number of postings differences.
     C                   IF        RECI = 'B'
      * Number of postings and difference.
     C                   EVAL      StoreCHQN = CHQN
     C                   EVAL      PostNumber = %EDITC(StoreCHQN:'K')
     C                   EVAL      S08PN1 = PostNumber
     C                   EVAL      PostTotal = %EDITC(SDCB:'K')
     C                   EVAL      S08PT1 = PostTotal
     C                   EVAL      S08NP1 = *blanks
     C                   EXSR      OverFlow
     C                   WRITE     DTL1
      *
     C                   EVAL      PostNumber = %EDITC(PTIM:'K')
     C                   EVAL      S08PN2 = PostNumber
     C                   EVAL      CHQN = CHQN - PTIM
     C                   EVAL      StoreCHQN = CHQN
     C                   EVAL      PostNumber = %EDITC(StoreCHQN:'K')
     C                   EVAL      S08NDF = PostNumber
     C                   EVAL      PostTotal = %EDITC(SDLB:'K')
     C                   EVAL      S08PT2 = PostTotal
     C                   EVAL      SDCB = SDCB - SDLB
     C                   EVAL      PostTotal = %EDITC(SDCB:'K')
     C                   EVAL      S08TDF = PostTotal
     C                   EVAL      S08NP2 = *blanks
     C                   WRITE     DTL2
      *
      * If postings not existing in 'old' system.
     C                   ELSE
     C                   IF        RECI = 'N'
     C                   EVAL      S08NP1 = %TRIMR(NotFound) + ' ' + PFmLib
     C                   EVAL      S08PN1 = *blanks
     C                   EVAL      S08PT1 = *blanks
     C                   EXSR      OverFlow
     C                   WRITE     DTL1
      *
     C                   EVAL      StoreCHQN = CHQN
     C                   EVAL      PostNumber = %EDITC(StoreCHQN:'K')
     C                   EVAL      S08PN2 = PostNumber
     C                   EVAL      S08NDF = *blanks
     C                   EVAL      PostTotal = %EDITC(SDCB:'K')
     C                   EVAL      S08PT2 = PostTotal
     C                   EVAL      S08TDF = *blanks
     C                   EVAL      S08NP2 = *blanks
     C                   WRITE     DTL2
      *
      * If postings not existing in 'new' system.
     C                   ELSE
     C                   IF        RECI = 'O'
     C                   EVAL      StoreCHQN = CHQN
     C                   EVAL      PostNumber = %EDITC(StoreCHQN:'K')
     C                   EVAL      S08PN1 = PostNumber
     C                   EVAL      PostTotal = %EDITC(SDCB:'K')
     C                   EVAL      S08PT1 = PostTotal
     C                   EVAL      S08NP1 = *blanks
     C                   EXSR      OverFlow
     C                   WRITE     DTL1
      *
     C                   EVAL      S08NP2 = %TRIMR(NotFound) + ' ' + PToLib
     C                   EVAL      S08PN2 = *blanks
     C                   EVAL      S08PT2 = *blanks
     C                   EVAL      S08NDF = *blanks
     C                   WRITE     DTL2
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      UPPOSTPD
     C                   ENDDO
      *
     C                   EVAL      RqdLines = 2
     C                   EXSR      OverFlow
     C                   WRITE     TRAILP
     C                   CLOSE     UP000008P1
      *
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *
     C     OverFlow      BEGSR
      *
     C                   EVAL      RemainLn = OverFlowLn - PrintLn
     C                   IF        RemainLn < RqdLines
     C                   WRITE     MAINH
     C                   EVAL      S08SRC = SPOS
     C                   ENDIF
      *
     C     OverFlowE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      ********************************************************************
