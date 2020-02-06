     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Default Loan Sub Type and Class')
      *****************************************************************
      *                                                               *
      *  Midas - Lending                                              *
      *                                                               *
      *  LE002000 - Default Loan Sub Type and Class                   *
      *                                                               *
      *  Function:  This program may default loan sub-type and        *
      *             class based on attibutes of the loan.             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CLE042  *CREATE    Date 06Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE042 - Extended Loan Sub Type                              *
      *                                                               *
      *****************************************************************
      /COPY WNCPYSRC,LE00200001
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      /COPY WNCPYSRC,LE00200002
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      /COPY WNCPYSRC,LE00200003
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      /COPY WNCPYSRC,LE00200004
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      /COPY WNCPYSRC,LE00200005
 
     D @RUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * MAIN - Main Processing
 
     C     @ActionCode   IFEQ      'I'
     C                   EXSR      MAIN
     C                   ENDIF
 
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      * MAIN - Main Processing                                        *
      *****************************************************************
     C     MAIN          BEGSR
      /COPY WNCPYSRC,LE00200006
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      * Called by: Implicitly on program activation                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Inputs
     C                   PARM                    @ActionCode       1
     C                   PARM                    @LoanType         2
     C                   PARM                    @Customer        10
     C                   PARM                    @ValueDate        6
     C                   PARM                    @MaturityDate     6
     C                   PARM                    @BookCode         2
     C                   PARM                    @ProfitCentre     4
     C                   PARM                    @CurrencyL        3
     C                   PARM                    @CurrencyF        3
     C                   PARM                    @RelatedLoan      6
      * Inputs/Outputs
     C                   PARM                    @LoanSubType      2
     C                   PARM                    @LoanClass        4
      *
      /COPY WNCPYSRC,LE00200007
      *
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   DUMP
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
      /COPY WNCPYSRC,LE00200008
