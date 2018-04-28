     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Determine if trans typ/sub typ to be ext')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GODETTSEX - Determine if transaction type/sub type is to be  *
      *              extracted.                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPPRODXL0 IF   E           K DISK    INFSR(*PSSR)
     FGPINSTXL0 IF   E           K DISK    INFSR(*PSSR)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      * Transaction Type/Sub Types to be extracted
     D EX_TTST         S             10A   DIM(500)
     D EX_PROD         S              1A   DIM(500)
     D EX_INST         S              1A   DIM(500)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
 
     C                   PARM                    I#ZONE           10            * ERROR MESSAGE
     C                   PARM                    I#MOD             2            * ERROR MESSAGE
     C                   PARM                    I#TRTP            5
     C                   PARM                    I#TRST            5
      * OUTPUTS
     C                   PARM                    O#PROD            1
     C                   PARM                    O#INST            1
      *
      * Check if transaction type/sub type is to be extracted
      * (according to whether it is linked to a product or instrument)
      *
     C                   MOVEL     I#TRTP        TransTpSbTp      10
     C                   MOVE      I#TRST        TransTpSbTp
 
     C                   Z-ADD     1             I                 5 0
     C     TransTpSbTp   LOOKUP    EX_TTST(I)                             99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEL     EX_PROD(I)    O#PROD
     C                   MOVEL     EX_INST(I)    O#INST
     C                   ELSE
     C                   MOVEL     'N'           O#PROD
     C                   MOVEL     'N'           O#INST
     C                   ENDIF
 
      * No extract
 
     C     O#PROD        IFEQ      'N'
     C     O#INST        ANDEQ     'N'
     C                   MOVEL     '*NOEXT*'     I#RTCD
     C                   ENDIF
 
     C                   RETURN
 
     C/SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
 
 
      * Get Extract control information
 
      /COPY GOCPYSRC,GOGETEXCT
 
 
      * Load up transaction types/sub types to be extracted
 
      * Products
      * --------
     C     ZoneModK      SETLL     GPPRODXD0
     C     ZoneModK      READE     GPPRODXD0                              99
     C     *IN99         DOWEQ     *OFF
 
     C                   MOVEL     PDTRTP        TransTpSbTp
     C                   MOVE      PDTRST        TransTpSbTp
     C                   Z-ADD     1             I                 5 0
     C     TransTpSbTp   LOOKUP    EX_TTST(I)                             99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    EX_TTST(I)                             99
     C                   MOVEL     TransTpSbTp   EX_TTST(I)                     *
     C                   ENDIF
     C                   MOVEL     'Y'           EX_PROD(I)
 
     C     ZoneModK      READE     GPPRODXD0                              99
     C                   ENDDO
 
      * Instruments
      * -----------
     C     ZoneModK      SETLL     GPINSTXD0
     C     ZoneModK      READE     GPINSTXD0                              99
     C     *IN99         DOWEQ     *OFF
 
     C                   MOVEL     INTRTP        TransTpSbTp
     C                   MOVE      INTRST        TransTpSbTp
     C                   Z-ADD     1             I
     C     TransTpSbTp   LOOKUP    EX_TTST(I)                             99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    EX_TTST(I)                             99
     C                   MOVEL     TransTpSbTp   EX_TTST(I)                     *
     C                   ENDIF
     C                   MOVEL     'Y'           EX_INST(I)
 
     C     ZoneModK      READE     GPINSTXD0                              99
     C                   ENDDO
      *
     C     ZoneModK      KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    I#MOD
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
