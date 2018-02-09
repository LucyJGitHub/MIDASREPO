     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - SE')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGLOBSE - Global Updates - SE                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      *                 AR1048651          Date 07Feb13               *
      *                 CER049             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL035             Date 01Mar05               *
      *                 CGP007             Date 10Nov04               *
      *                 222727             Date 05Nov03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  AR1048651 - TRADSDX1 global replication (Child:AR1048654)    *
      *  CER049 - Stamp Tax                                           *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CGP007 - Depot Positions Global View                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
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
     C     TRGEVENT      IFEQ      '1'                                          * DELETE
     C                   MOVEL     *BLANK        I#BIMG
     C                   ENDIF
     C     TRGEVENT      IFEQ      '2'                                          * DELETE
     C                   MOVEL     *BLANK        I#AIMG
     C                   ENDIF
 
     C                   MOVEL     O#ZONE        I#ZONE                         * ERROR MESSAGE
     C                   MOVEL     'Y'           I#TRAP
 
      * Determine updates                                                                     222727
                                                                                              222727
     C                   EXSR      DET_UPDATES                                                222727
                                                                                              222727
     C                   MOVEL     'B'           I#BFAF                                       222727
     C                   DO        2                                                          222727
                                                                                              222727
     C     P_Before      IFEQ      'Y'                                                        222727
     C     I#BFAF        ANDEQ     'B'                                                        222727
     C     P_After       OREQ      'Y'                                                        222727
     C     I#BFAF        ANDEQ     'A'                                                        222727
     C     PFLNAME       CASEQ     'BKPHDD'      GLOB_BKPHDD
     C     PFLNAME       CASEQ     'BKPOSD'      GLOB_BKPOSD
     C     PFLNAME       CASEQ     'CPOSND'      GLOB_CPOSND
     C     PFLNAME       CASEQ     'DPOSND'      GLOB_DPOSND
     C     PFLNAME       CASEQ     'DPTMVD'      GLOB_DPTMVD
     C     PFLNAME       CASEQ     'INVTPD'      GLOB_INVTPD
     C     PFLNAME       CASEQ     'PRICED'      GLOB_PRICED
     C     PFLNAME       CASEQ     'SECGTD'      GLOB_SECGTD
     C     PFLNAME       CASEQ     'SECTYD'      GLOB_SECTYD
     C     PFLNAME       CASEQ     'SEDEVD'      GLOB_SEDEVD
     C     PFLNAME       CASEQ     'SEMKCD'      GLOB_SEMKCD
     C     PFLNAME       CASEQ     'TRADSD'      GLOB_TRADSD
     C     PFLNAME       CASEQ     'CDEPPD'      GLOB_CDEPPD                                  CGP007
     C     PFLNAME       CASEQ     'UDEPPD'      GLOB_UDEPPD                                  CGP007
     C     PFLNAME       CASEQ     'TRADSDQD'    GLOB_TRADSDQD                                CER049
     C     PFLNAME       CASEQ     'TRADSDX1'    GLOB_TRADSDX1                             AR1048651
     C                   ENDCS
     C                   ENDIF                                                                222727
                                                                                              222727
     C                   MOVEL     'A'           I#BFAF                                       222727
     C                   ENDDO                                                                222727
 
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * Global Updates - Book Position Headers
      *****************************************************************
     C     GLOB_BKPHDD   BEGSR
      /COPY GPCPYSRCG,GPBKPHDD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Book Positions
      *****************************************************************
     C     GLOB_BKPOSD   BEGSR
      /COPY GPCPYSRCG,GPBKPOSD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Customer Positions
      *****************************************************************
     C     GLOB_CPOSND   BEGSR
      /COPY GPCPYSRCG,GPCPOSND
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Depot Positions
      *****************************************************************
     C     GLOB_DPOSND   BEGSR
      /COPY GPCPYSRCG,GPDPOSND
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Depot Movement
      *****************************************************************
     C     GLOB_DPTMVD   BEGSR
      /COPY GPCPYSRCG,GPDPTMVD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Investment Type
      *****************************************************************
     C     GLOB_INVTPD   BEGSR
      /COPY GPCPYSRCG,GPINVTPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Price
      *****************************************************************
     C     GLOB_PRICED   BEGSR
      /COPY GPCPYSRCG,GPPRICED
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - SE Charge Types
      *****************************************************************
     C     GLOB_SECGTD   BEGSR
      /COPY GPCPYSRCG,GPSECGTD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Security
      *****************************************************************
     C     GLOB_SECTYD   BEGSR
      /COPY GPCPYSRCG,GPSECTYD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Security Diary
      *****************************************************************
     C     GLOB_SEDEVD   BEGSR
      /COPY GPCPYSRCG,GPSEDEVD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Security Market Centres
      *****************************************************************
     C     GLOB_SEMKCD   BEGSR
      /COPY GPCPYSRCG,GPSEMKCD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Trade
      *****************************************************************
     C     GLOB_TRADSD   BEGSR
      /COPY GPCPYSRCG,GPTRADSD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CGP007
      *****************************************************************                       CGP007
      * Global Updates - Client Depot Positions                                               CGP007
      *****************************************************************                       CGP007
     C     GLOB_CDEPPD   BEGSR                                                                CGP007
      /COPY GPCPYSRCG,GPCDEPPD                                                                CGP007
     C                   ENDSR                                                                CGP007
      *****************************************************************                       CGP007
      /SPACE 5                                                                                CGP007
      *****************************************************************                       CGP007
      * Global Updates - User Depot Positions                                                 CGP007
      *****************************************************************                       CGP007
     C     GLOB_UDEPPD   BEGSR                                                                CGP007
      /COPY GPCPYSRCG,GPUDEPPD                                                                CGP007
     C                   ENDSR                                                                CGP007
      *****************************************************************                       CGP007
      /SPACE 5                                                                                222727
      *****************************************************************                       CER049
      * Global Updates - Trades Detail Extension File                                         CER049
      *****************************************************************                       CER049
     C     GLOB_TRADSDQD BEGSR                                                                CER049
      /COPY GPCPYSRCG,GPTRADSDQD                                                              CER049
     C                   ENDSR                                                                CER049
      *****************************************************************                    AR1048651
      /SPACE 5                                                                             AR1048651
      *****************************************************************                    AR1048651
      * Global Updates - Trades Detail Extension File 1                                    AR1048651
      *****************************************************************                    AR1048651
     C     GLOB_TRADSDX1 BEGSR                                                             AR1048651
      /COPY GPCPYSRCG,GPTRADSDX1                                                           AR1048651
     C                   ENDSR                                                             AR1048651
      *****************************************************************                       CER049
     C/SPACE 5                                                                                CER049
      *****************************************************************                       222727
      * Determine Updates                                                                     222727
      *****************************************************************                       222727
     C     DET_UPDATES   BEGSR                                                                222727
                                                                                              222727
     C                   CALL      'GPDETGUPD'                                                222727
     C                   PARM                    I#ZONE           10                          222727
     C                   PARM      PFLNAME       I#FILE           10                          222727
     C                   PARM                    I#BIMG                                       222727
     C                   PARM                    I#AIMG                                       222727
     C                   PARM      'N'           P_Before          1                          222727
     C                   PARM      'N'           P_After           1                          222727
                                                                                              222727
     C                   ENDSR                                                                222727
      *****************************************************************                       222727
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
