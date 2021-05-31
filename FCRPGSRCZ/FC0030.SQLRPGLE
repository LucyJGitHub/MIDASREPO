     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Retrieve report parameters')
     F********************************************************************
     F*                                                                  *
     F*  Midas - Report Control Facility Module
     F*                                                                  *
     F*  FC0030 - PERIODIC REQUESTS ENQUIRY                              *
     F*                                                                  *
     F*  (c) Finastra International Limited 2001                         *
     F*                                                                  *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                                      DATE 00/00/00               *
     F*                                      DATE 00/00/00               *
      ********************************************************************
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      ********************************************************************
      *  C R E A T I O N     P A R A M E T E R S
      *
      *
      ********************************************************************
      *****************************************************************
      * OPERATION
      * ~~~~~~~~~
      *
      *
      *      INDICATORS: 88 - RECORD FOUND INDICATOR
      *
      *****************************************************************
      *
      *****************************************************************
      * FILE DECLARATION
      *****************************************************************
      *
     F*FCRCOML1* IF   E           K DISK                                                    MD055265
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      **
      * DATA STRUCTURE FOR DATABASE ERROR
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      **
      * DATA STRUCTURE FOR FIELDS IN KLIST (FOR ERROR HANDLING)
      *
     D PFLDS           DS            25
     D  FPRPG                  1     10
     D  FPGCL                 11     20
     D  FOCCU                 20     25
     D FCRCOM        E DS                  EXTNAME(FCRCOJW0)                                MD055265
      *****************************************************************
      *         INITIALISE PARAMATER LIST, SET KEY.
      *****************************************************************
      **
     C                   MOVEA     CPY@          BIS@             80
     C     *DTAARA       DEFINE                  LDA
      *
      **
      * PARAMETER PASSED FROM       :
      **
     C     *ENTRY        PLIST
     C                   PARM                    PGRPG            10
     C                   PARM                    PGCL             10
     C                   PARM                    OCCU              5
     C                   PARM                    PARMS           100
     C                   PARM                    PNAM             10
     C**
     C* KLIST TO READ FCRCOML1
     C*
     C     PARMKY        KLIST
     C                   KFLD                    PGRPG
     C                   KFLD                    PGCL
     C                   KFLD                    OCCU
      *****************************************************************
      * MAIN
      *****************************************************************
      *
     C                   EXSR      BCHAIN
     C                   EXSR      CTERM
      ********PROG END
      /EJECT
      *****************************************************************
      *                 SUBROUTINES
      *
      * BCHAIN - PERFORMS CHAIN TO FCRCOML1
      * BANOTF - PERFORMED IF NO RECORD FOUND IN FCRCOML1
      * *PSSR  - DATABASE ERROR HANDLING ROUTINE
      * BBRFND - PERFORMED IF RECORD FOUND IN FCRCOML1
      * CTERM  - PROGRAM EXIT ROUTINE
      *****************************************************************
      /EJECT
      *****************************************************************
      *BCHAIN - CHAIN TO FCRCOML1 USING PARMKEY
      *(CALLED FROM MAIN)
      *****************************************************************
     C     BCHAIN        BEGSR
     C*****PARMKY        CHAIN     FCRCOML1                           88                    MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRCOM                                                                        MD055265
     C+ from FCRCOJW0                                                                       MD055265
     C+ where D3RNAM = :PGRPG and D3COTT = :PGCL and D3CSEQ = :OCCU                         MD055265
     C/END-EXEC                                                                             MD055265
     C******IN88         IFEQ      '1'                                                      MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C                   EXSR      BANOTF
     C                   ELSE
     C                   EXSR      BBRFND
     C                   END
     C                   ENDSR
      *****************************************************************
      * BANOTF - RECORD NOT FOUND
      * (CALLED FROM BCHAIN)
      *****************************************************************
      *
     C     BANOTF        BEGSR
     C     *LOCK         IN        LDA
      * MOVE VARIABLES INTO PFLDS *
     C                   MOVEL     PGRPG         FPRPG
     C                   MOVEL     PGCL          FPGCL
     C                   MOVEL     OCCU          FOCCU
      *
     C                   MOVEL     'FCRCOML1'    DBFILE
     C                   MOVEL     PFLDS         DBKEY                          ************
     C                   MOVEL     'FC0030'      DBPGM                          *DBERR 001 *
     C                   MOVEL     '001'         DBASE                          ************
     C                   EXSR      *PSSR
     C                   SETON                                        U7U8
     C                   OUT       LDA
     C                   ENDSR
      *****************************************************************
      * *PSSR - DATABASE ERROR HANDLING ROUTINE
      * (CALLED FROM BANOTF)
      *****************************************************************
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C                   ENDSR
      *****************************************************************
      * BBRFND - RECORD FOUND
      * (CALLED FROM BCHAIN)
      *****************************************************************
     C     BBRFND        BEGSR
     C                   MOVE      D3CLPM        PARMS
     C                   MOVE      D3PRPG        PNAM
     C                   ENDSR
      *****************************************************************
      * CTERM - PROGRAM EXIT
      * (CALLED FROM MAIN)
      *****************************************************************
     C     CTERM         BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
** CPY@
(c) Finastra International Limited 2001
