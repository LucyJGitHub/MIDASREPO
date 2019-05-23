     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - FF')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGLOBFF - Global Updates - FF                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGP017             Date 06Aug12               *
      *                 CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP191             Date 26Nov09               *
      *                 261610             Date 03Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BG1364             Date 04Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption (Recompile)                     *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  CAP208 - F&O Market Instrument API                           *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs (Recompile)       *
      *  261610 - Amend program to cater the new Global FF file       *
      *           GZTRANSD.                                           *
      *  BG1364 - Filter Duplicate records in Bulk Synchronization    *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     D/COPY ZACPYSRC,STD_D_SPEC


     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A


     D PARM2           DS
     D  LENG                   1      4B 0


      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2

      * Recover before and after image

     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000

     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000


      * Global Updates - BEFORE/AFTER image
      * TRGEVENT: '1'=INSERT, '2'=DELETE, '3'=UPDATE
     C     TRGEVENT      IFEQ      '1'
     C                   MOVEL     *BLANK        I#BIMG
     C                   ENDIF
     C     TRGEVENT      IFEQ      '2'
     C                   MOVEL     *BLANK        I#AIMG
     C                   ENDIF

     C                   MOVEL     O#ZONE        I#ZONE                         * ERROR MESSAGE
     C                   MOVEL     'Y'           I#TRAP

      * Determine updates

     C                   EXSR      DET_UPDATES

     C                   MOVEL     'B'           I#BFAF
     C                   DO        2

     C     P_Before      IFEQ      'Y'
     C     I#BFAF        ANDEQ     'B'
     C     P_After       OREQ      'Y'
     C     I#BFAF        ANDEQ     'A'
     C     PFLNAME       CASEQ     'CHGCMD  '    GLOB_CHGCMD                                  BG1364
     C     PFLNAME       CASEQ     'INTYPD  '    GLOB_INTYPD
     C     PFLNAME       CASEQ     'POSTNCD '    GLOB_POSTNCD
     C     PFLNAME       CASEQ     'POSTNKD '    GLOB_POSTNKD
     C     PFLNAME       CASEQ     'TRANSD  '    GLOB_TRANSD
     C     PFLNAME       CASEQ     'TRSETD  '    GLOB_TRSETD
     C     PFLNAME       CASEQ     'MARKTD  '    GLOB_MARKTD                                  CAP208
     C                   ENDCS
     C                   ENDIF

     C                   MOVEL     'A'           I#BFAF
     C                   ENDDO

     C                   RETURN

      /SPACE 5                                                                                BG1364
      *****************************************************************                       BG1364
      * Global Updates - FF Charges & Commissions                                             BG1364
      *****************************************************************                       BG1364
     C     GLOB_CHGCMD   BEGSR                                                                BG1364
      /COPY GPCPYSRCG,GPCHGCMD                                                                BG1364
     C                   ENDSR                                                                BG1364
      *****************************************************************                       BG1364
      /SPACE 5
      *****************************************************************
      * Global Updates - Instrument Types
      *****************************************************************
     C     GLOB_INTYPD   BEGSR
      /COPY GPCPYSRCG,GPINTYPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Customer/Broker Positions
      *****************************************************************
     C     GLOB_POSTNCD  BEGSR
      /COPY GPCPYSRCG,GPPOSTNCD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Book Positions
      *****************************************************************
     C     GLOB_POSTNKD  BEGSR
      /COPY GPCPYSRCG,GPPOSTNKD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Transactions
      *****************************************************************
     C     GLOB_TRANSD   BEGSR
     C*****MBRNAME       IFEQ      'OTC'                                                      261610
      **OTC************************************************************                       261610
      ***COPY*GPCPYSRCG,GPFFOTCCPD                                                            261610
     C**********         ELSE                                                                 261610
      **Exchange*Traded************************************************                       261610
      ***COPY**GPCPYSRCG,GPFFEXTRPD                                                           261610
     C**********         ENDIF                                                                261610
      /COPY GPCPYSRCG,GPTRANSDPD                                                              261610
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Transaction Settlement Details
      *****************************************************************
     C     GLOB_TRSETD   BEGSR
      /COPY GPCPYSRCG,GPTRSETD
     C                   ENDSR
      /SPACE 5                                                                                CAP208
      *****************************************************************                       CAP208
      * Global Updates - Market Centres Details                                               CAP208
      *****************************************************************                       CAP208
     C     GLOB_MARKTD   BEGSR                                                                CAP208
      /COPY GPCPYSRCG,GPMARKTD                                                                CAP208
     C                   ENDSR                                                                CAP208
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Determine Updates
      *****************************************************************
     C     DET_UPDATES   BEGSR

     C                   CALL      'GPDETGUPD'
     C                   PARM                    I#ZONE           10
     C                   PARM      PFLNAME       I#FILE           10
     C                   PARM                    I#BIMG
     C                   PARM                    I#AIMG
     C                   PARM      'N'           P_Before          1
     C                   PARM      'N'           P_After           1

     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR

     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50

      * Get Zone

      /COPY GOCPYSRC,GOGETZONE

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
