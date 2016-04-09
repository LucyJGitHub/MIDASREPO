     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE Automated Telekurs (prepare TDFF63)')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading                                   *
      *                                                               *
      *  SEFPCLIA - Build TDFF63 based on STSECPD for                 *
      *             Telekurs Autom. (Previously ICFPCLIA in Midas     *
      *             lower release)                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
/*    *  Last Amend No. CSE067  *CREATE    Date 25Apr05               *
      *                                                               *
      *****************************************************************
      *                                                               *
/*    *  CSE067 - Telekurs Interface Changes                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SE Telekurs number for securities
     FSETKSEPD  IP   F   15     9AIDISK    KEYLOC(3)
     F                                     EXTIND(*INU2)
     FTDFF63    O    F   45        DISK
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D/EJECT
 
      ** Array Definition
 
     D A               S              1    DIM(50)
     D MSG             S             28    DIM(1) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     I/EJECT
 
      ** Redefinition of STSECPO
 
     ISETKSEPD  NS  01
     I                                  1   15  LOTD
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C/EJECT
      *
      ** Calculate number of record to send to SERVITIA and DSIPLAY
      *
     C                   ADD       1             ZRCD              5 0
      *
     CLR                 MOVE      ZRCD          ZCTR0             5
     CLR                 MOVEA     ZCTR0         A(1)
     CLR                 MOVEA     MSG           A(7)
     CLR                 MOVEA     A             B                50
     CLR   B             DSPLY     'QSYSOPR'
 
      ** +--------------------------------------+
      ** ¦ O-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     O/EJECT
      *
      ** Output details for TDFF63
      *
     OTDFF63    D    01
     O                                            3 '002'
     O                       LOTD                18
      *
**
RECORDS A ENVOYER A SERVITIA
