     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*XBI *  CRTPF FILE(QTEMP/UPSBSD) RCDLEN(132)                         *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Global Layer Chg subsys. routing entries')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000121 - Change subsystem routing entries - classes        *
      *             (Global Layer)                                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CUP027 *CREATE     Date 23Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP027 - Global layer migration of Bridge ICD to the System  *
      *           Values file.                                        *
      *                                                               *
      *****************************************************************
     FUPSBSD    IF   E             DISK
     F                                     RENAME(UPSBSD:RTGE)
      /EJECT
      *
     D CMD             S             80    DIM(1) CTDATA PERRCD(1)
      *
     D CMDDTA          DS            80
     D  CHGRTG                 1     80
     D  SBS1                  14     15
     D  SBS2                  23     24
     D  SEQN                  38     41
     D  CLS                   54     63
      * Breakdown of CHGRTGE instruction
      *
     D INPUT           DS           132
     D  ROUTIN                 2      7
     D  SEQNI                 76     79
     D  SEQNO                 76     79  0
     D  CLSI                  76     85
      /SPACE 3
      *
     IRTGE
      * Renamed input format fields
     I              UPSBSD                      SBSDTA
      *
     C     *ENTRY        PLIST
     C                   PARM                    SBSID             2
     C                   PARM                    ERROR             1
      *
      * Set up parameters for call to QCMDEXC
     C                   Z-ADD     80            MSGLEN           15 5
     C                   MOVEL     CMD(1)        CHGRTG
     C                   MOVEL     SBSID         SBS1
     C                   MOVEL     SBSID         SBS2
      *
      * Read file until Routing Entry Sequence section found
     C                   READ      UPSBSD                               6970
     C     *IN69         IFEQ      *ON                                          I01
     C                   MOVE      'Y'           ERROR
     C                   SETON                                        70
     C                   ELSE                                                   X01
      *
     C                   MOVEL     SBSDTA        INPUT
     C                   ENDIF                                                  E01
      *
     C     *IN70         DOUEQ     *ON                                          DO01
     C     ROUTIN        IFEQ      'Routin'                                     I01
      * Move routing entry sequence number into command line
     C                   MOVEL     SEQNI         SEQN
     C                   SETON                                        88
      *
     C                   ELSE                                                   X01
     C     ROUTIN        IFEQ      'Class '                                     I02
      * Move routing entry sequence number into command line
     C                   MOVEL     CLSI          CLS
     C                   SETON                                        89
     C                   ENDIF                                                  E02
     C                   ENDIF                                                  E01
      *
      * If both 88 and 89 are on then perform change
     C     *IN88         IFEQ      *ON                                          I01
     C     *IN89         ANDEQ     *ON                                          -01
      *
     C                   CALL      'QCMDEXC'                            9393
     C                   PARM                    CHGRTG
     C                   PARM                    MSGLEN
      *
     C                   SETOFF                                       8889
     C                   ENDIF                                                  E01
      *
     C                   READ      UPSBSD                               6970
     C     *IN69         IFEQ      *ON                                          I01
     C                   MOVE      'Y'           ERROR
     C                   SETON                                        70
     C                   ELSE                                                   X01
      *
     C                   MOVEL     SBSDTA        INPUT
     C                   ENDIF                                                  E01
      *
     C                   ENDDO                                                  ED01
      *
     C                   SETON                                        LR
     C                   RETURN
      ********************************************************************
**  CMD
CHGRTGE SBSD(xxGXLIB/MxxGSBS) SEQNBR(nnnn) CLS(*LIBL/cccccccccc)
