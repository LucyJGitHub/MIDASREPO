     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas DL Default Deal Sub Type and Class')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing                                              *
      *                                                               *
      *  DL002000 - Default Deal Sub Type and Class                   *
      *                                                               *
      *  Function:  This program may default deal sub-type and        *
      *             class based on attibutes of the deal.             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG9717            Date 16Jan06               *
      *                 CDL038  *CREATE    Date 10May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG9717 - Remove these unnecessary codes (Recompile)         *
      *  CDL038 - Extended Deal Sub Type                              *
      *                                                               *
      *****************************************************************
      /COPY WNCPYSRC,DL00200001
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      /COPY WNCPYSRC,DL00200002
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      /COPY WNCPYSRC,DL00200003
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      /COPY WNCPYSRC,DL00200004
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      /COPY WNCPYSRC,DL00200005
 
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
      /COPY WNCPYSRC,DL00200006
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
     C                   PARM                    @DealType         2
     C                   PARM                    @Customer        10
     C                   PARM                    @ValueDate        6
     C                   PARM                    @MaturityDate     6
     C                   PARM                    @BookCode         2
     C                   PARM                    @ProfitCentre     4
     C                   PARM                    @Currency1        3
     C                   PARM                    @Currency2        3
     C                   PARM                    @RelatedDeal      6
      * Inputs/Outputs
     C                   PARM                    @DealSubType      2
     C                   PARM                    @DealClass        4
      *
      /COPY WNCPYSRC,DL00200007
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
      /COPY WNCPYSRC,DL00200008
