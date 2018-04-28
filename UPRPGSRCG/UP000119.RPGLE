     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*XBI *  CRTPF FILE(QTEMP/UPSBSD) RCDLEN(132)                         *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Change subsystem routing entries')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000119 - Change subsystem routing entries                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CUP025  *CREATE    Date 01Dec03               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP025 - MidasPlus Bridge changes                            *
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
     D  PGM                   54     63
      * Breakdown of CHGRTGE instruction
      *
     D INPUT           DS           132
     D  SEQNI                 14     17
     D  SEQNO                 14     17  0
     D  PGMI                  27     36
     D  ROUTIN                34     39
      /SPACE 3
      *
     IRTGE
      * Renamed input format fields
     I              UPSBSD                      SBSDTA
      * Breakdown of field input from UPSBSD
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
      * Read file until Routing Entry section found
     C                   READ      UPSBSD                               6970
     C     *IN69         IFEQ      *ON                                          I01
     C                   MOVE      'Y'           ERROR
     C                   ELSE                                                   X01
      *
     C                   MOVEL     SBSDTA        INPUT
     C     *IN70         DOUEQ     *ON                                          DO01
     C     ROUTIN        IFEQ      'Routin'                                     I02
     C                   SETON                                        89
     C                   ENDIF                                                  E02
      *
     C                   READ      UPSBSD                               6970
     C     *IN69         IFEQ      *ON                                          I02
     C                   MOVE      'Y'           ERROR
     C                   ELSE                                                   X02
      *
     C                   MOVEL     SBSDTA        INPUT
     C     *IN89         IFEQ      *ON                                          I03
      *
      * Ignore heading lines in file
     C     SEQNI         IFNE      ' Seq'                                       I04
     C     SEQNI         ANDNE     ' Nbr'
      *
      * If PGM is blank this should indicate end of routing entries; also ignore
      * 'special case' routing entries
     C     PGMI          IFNE      *BLANK                                       I05
     C     PGMI          ANDNE     'QCMD'
     C     PGMI          ANDNE     'QARDRIVE'
     C     PGMI          ANDNE     '*RTGDTA'
     C                   MOVEL     PGMI          PGM
     C                   MOVEL     SEQNO         SEQN
     C                   CALL      'QCMDEXC'                            9393
     C                   PARM                    CHGRTG
     C                   PARM                    MSGLEN
     C                   ELSE                                                   X05
      * If blank then finish processing
     C     PGMI          IFEQ      *BLANK                                       I06
     C                   SETOFF                                       89
     C                   SETON                                        70
     C                   ENDIF                                                  E06
     C                   ENDIF                                                  E05
     C                   ENDIF                                                  E04
     C                   ENDIF                                                  E03
     C                   ENDIF                                                  E02
      *
     C                   ENDDO                                                  ED01
     C                   ENDIF                                                  E01
      *
     C                   SETON                                        LR
     C                   RETURN
      ********************************************************************
**  CMD
CHGRTGE SBSD(xxGXLIB/MxxGSBS) SEQNBR(nnnn) PGM(*LIBL/pppppppppp)
