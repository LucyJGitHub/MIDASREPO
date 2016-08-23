     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - RE')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGLOBRE - Global Updates - RE                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD035554           Date 25May16               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG27288           Date 07Apr10               *
      *                 CAP202             Date 10Feb10               *
      *                 CAP187             Date 21Aug09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035554 - 2o'clock/ABC Compatibility                        *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  BUG27288 - A serios Midas error has occured message comes    *
      *             up when completing insert for Batch Details       *
      *             in GL - JRNE                                      *
      *  CAP202 - Retail Account Balance Enquiry                      *
      *  CAP187 - Document Linkage (Recompile)                        *
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
     C     PFLNAME       CASEQ     'CUSEXCE   '  GLOB_CUSEXCE
     C     PFLNAME       CASEQ     'HELDIHB   '  GLOB_HELDIHB
     C     PFLNAME       CASEQ     'STANDSB   '  GLOB_STANDSB
     C     PFLNAME       CASEQ     'STOPCSD   '  GLOB_STOPCSD
     C*****PFLNAME       CASEQ     'RERABEPD  '  GLOB_RERABEPD                       CAP202 BUG27288
     C     PFLNAME       CASEQ     'RE2CLKPD  '  GLOB_RE2CLKPD                              MD035554
     C     PFLNAME       CASEQ     'REMEMLPD  '  GLOB_REMEMLPD                              MD035554
     C     PFLNAME       CASEQ     'RETTYPPD  '  GLOB_RETTYPPD                              MD035554
     C                   ENDCS
     C                   ENDIF

     C                   MOVEL     'A'           I#BFAF
     C                   ENDDO

     C                   RETURN

      /SPACE 5
      *****************************************************************
      * Global Updates - Customer Exchanges
      *****************************************************************
     C     GLOB_CUSEXCE  BEGSR
      /COPY GPCPYSRCG,GPCUSEXCE
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Held Items
      *****************************************************************
     C     GLOB_HELDIHB  BEGSR
      /COPY GPCPYSRCG,GPHELDIHB
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Standing Orders
      *****************************************************************
     C     GLOB_STANDSB  BEGSR
      /COPY GPCPYSRCG,GPSTANDSB
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Stopped Cheques
      *****************************************************************
     C     GLOB_STOPCSD  BEGSR
      /COPY GPCPYSRCG,GPSTOPCSD
     C                   ENDSR
      /SPACE 5                                                                                CAP202
      *****************************************************************                     MD035554
      * Global Updates - 2o'clock Flag                                                      MD035554
      *****************************************************************                     MD035554
     C     GLOB_RE2CLKPD BEGSR                                                              MD035554
      /COPY GPCPYSRCG,GPRE2CLKPD                                                            MD035554
     C                   ENDSR                                                              MD035554
      /SPACE 5                                                                              MD035554
      *****************************************************************                     MD035554
      * Global Updates - Outward Clearing Shadow                                            MD035554
      *****************************************************************                     MD035554
     C     GLOB_REMEMLPD BEGSR                                                              MD035554
      /COPY GPCPYSRCG,GPREMEMLPD                                                            MD035554
     C                   ENDSR                                                              MD035554
      /SPACE 5                                                                              MD035554
      *****************************************************************                     MD035554
      * Global Updates - 2o'clock Transaction Type                                          MD035554
      *****************************************************************                     MD035554
     C     GLOB_RETTYPPD BEGSR                                                              MD035554
      /COPY GPCPYSRCG,GPRETTYPPD                                                            MD035554
     C                   ENDSR                                                              MD035554
      /SPACE 5                                                                              MD035554
      *****************************************************************                       CAP202
      * Global Updates - Account Balance Extract                                              CAP202
      *****************************************************************                       CAP202
     C*****GLOB_RERABEPD BEGSR                                                       CAP202 BUG27288
      */COPY*GPCPYSRCG,GPRERABEPD                                                    CAP202 BUG27288
     C**********         ENDSR                                                       CAP202 BUG27288
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
(c) Misys International Banking Systems Ltd. 2003
