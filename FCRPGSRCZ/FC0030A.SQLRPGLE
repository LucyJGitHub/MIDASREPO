     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Obtain initial menu parmameters')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Report Control Facility Module
     F*                                                               *
     F*  FC0030A - ACCESS COB COMPONENTS FILE FOR PARAMETERS FOR      *
     F*            REPORT REQUEST AT INPUT CYCLE INITIATION           *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 064115             Date 18Feb94               *
      *                 E00000             Date DDMmmYY               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
     F*  064115 - PROCESS REPORT COMPONENTS WHICH EXIST ON            *
     F*           SWITCHABLE FEATURES BY REPORT COMPONENTS FILE.      *
     F*           REPLACE LF/FCRCOML3 WITH JLF/FCRCOMJ3               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     FCBCMPNL0  IF   E           K DISK
     F***FCRCOML3IF  E           K        DISK                            064115
     F*FCRCOMJ3* IF   E           K DISK                                             064115 MD055265
     F*
      /SPACE 2
     F********************************************************************
     F*
     F*     C  L   FUNCTION OF INDICATORS
     F*
     F*
     F*    50      FAIL ON CHAIN TO CBCMPNL0
     F*****60      FAIL ON CHAIN TO FCRCOML3                              064115
     F*    60      FAIL ON CHAIN TO FCRCOMJ3                              064115
     F*       LR   END OF FILE
     F*
     F*    U7&U8   DATABASE ERROR
     F*
     F*****************************************************************
     F/EJECT
     D*
     D** COPYRIGHT ARRAY
     D*
     D*****************************************************************
     D/EJECT
     D*
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D**     LOCAL DATA AREA
     D*
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D** DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D*
     D CKEYDS          DS
     D  CMPNMX                 1     10
     D  CMPSQX                11     15
     I** DATA STRUCTURE FOR KEY FIELD CKEY TO BE MOVED INTO DBKEY FIELD
     I*
     D FCRCOM        E DS                  EXTNAME(FCRCOJW1)                                MD055265
     D NullInds        s              5i 0 dim(12)                                          MD055265
     I*****************************************************************
     I/EJECT
     C*
     C** LIST FOR PARAMETER PASSED TO PROGRAM
     C*
     C     *ENTRY        PLIST
     C                   PARM                    COMPNM           10
     C                   PARM                    COMPSQ            5
     C                   PARM                    DHCPRM
     C*
     C** KEY LIST FOR CHAIN TO CBCOMSL0
     C*
     C     CKEY          KLIST
     C                   KFLD                    COMPNM
     C                   KFLD                    COMPSQ
     C*
     C** SET UP PROGRAM NAME FOR DATABASE ERRORS
     C*
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'FC0030A '    DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C*
     C** CHAIN TO CBCMPNL0 FOR COMPONENT DETAILS
     C*
     C     CKEY          CHAIN     @DHREGG                            50
     C*
     C** IF COMPONENT NOT FOUND CHECK THE RCF FILE
     C** IN CASE ONLY DEFINED AS AN INPUT CYCLE REPORT
     C*
     C     *IN50         IFEQ      '1'
     C***********CKEY      CHAIN@RCOMAU              60                   064115
     C*****CKEY          CHAIN     FCRCOMJ3                           60              06411 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRCOM :NullInds                                                              MD055265
     C+ from FCRCOJW1                                                                       MD055265
     C+ where D3COTT = :COMPNM and D3CSEQ = :COMPSQ                                         MD055265
     C/END-EXEC                                                                             MD055265
     C                   MOVE      D3CLPM        DHCPRM
     C                   END
     C*
     C** RETURN TO CALLING PROGRAM
     C*
     C                   SETON                                        LR
     C*
      /EJECT
**CTDATA CPY@
(c) Finastra International Limited 2001
