     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas ME Verify network message')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Message Management Module
     F*                                                               *
     F*  ME1030 - Verify Network Message                              *
     F*                                                               *
     F*  Function:  This program verifies that an Incoming Message    *
     F*  may be added to the database                                 *
     F*                                                               *
     F*  Called By: ME1020  - Add Network Message To Database         *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 069250             Date 03May94               *
      *                 S01435             Date 23Jul93               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
     F*  069250 - Remove dummy OVRDBF command from creation parms.    *
     F*  S01435 - Incoming Message Management                         *
     F*                                                               *
     F*****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
/****F*:*OVRDBF*(File*in*program)*(file*on*system)******************:**   069250
     F*****************************************************************
     F*****************************************************************
     F*                                                               *
     F*  Indicator usage                                              *
     F*  ~~~~~~~~~~~~~~~                                              *
     F*                                                               *
     F*  50    First cycle                                            *
     F*  60    Invalid Message - chain fail/parameters don't match    *
     F*  90    Chain fail                                             *
     F*  99    EOF on Read                                            *
     F*                                                               *
     F*  U7/U8 Error Ocurred                                          *
     F*  LR    End program                                            *
     F*                                                               *
     F*****************************************************************
     F*MEINMVL1* IF   E           K DISK    INFSR(SRFILE)                                   MD058081
     F**********                           USROPN                                           MD058081
      *
      *  Valid Message Control File
      *
     F/COPY WNCPYSRC,ME1030DFPG
      *
      *  /Copy point for File Definition
      *
      ** Array of Commitment Job Names                                                        CSC022
     D CMTJOB          S             10    DIM(10)
     F/EJECT
      *
      *  Copyright table
      *
     D/COPY WNCPYSRC,ME1030DEPG
      *
      *  /Copy point for Arrays
      *
     D*COPY*MECPYSRC,SRERRE                                                                 MD058081
     D/COPY MECPYSRC,SRERRELE                                                               MD058081
      *
      *  End of Copysource for error processing
      *
     D/EJECT
     D/COPY WNCPYSRC,ME1030DIPG
      *
      *  /Copy point for Input specifications
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      *  Define rundat data area
      *
     D INMC          E DS                  EXTNAME(MEINMCPD)
     D MEINMV        E DS                  EXTNAME(MEIVMJW0)                                MD058081
      *
      *  Define parameters to be passed for message checking
      *
     D*COPY*MECPYSRC,SRERRI                                                                 MD058081
     D/COPY MECPYSRC,SRERRILE                                                               MD058081
      *
      *  End of Program Error Processing source
      *
      *
     D SCCMT           DS           256
     D  CMTNUM                 1      3  0
     D  CMTARR                 4    103
     I/EJECT
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *  Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0ACT             8
     C                   PARM                    W0DATA
     C                   PARM                    W0RTN             7
      *
      *  Set up primary reference
      *
     C                   MOVEL     W0DATA        W0PREF
      *
      *  Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
      *  Verify Details
      *
     C                   EXSR      SRVERY
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *  Return to calling program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRVERY   : Verify that message may be added to the database. *
      *                                                               *
      *  CALLED BY: Main processing section                           *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRVERY        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRVERY'      @STK(Q)
      *
      * Move passed parameter to data structure
      *
     C                   MOVEL     W0DATA        INMC
      *
      * Access Incoming Valid Messages File. This determines if the
      * Incoming Message may be processed dependant on the value of the
      * Network, Sender and Message Type fields of the message and the
      * value of the Access Point that is set in the calling program.
      *
      * The Msg Type, Sender and Access Point fields are optional on
      * the Incoming Valid Messages file but the passed parameters will
      * always hold a value.
      *
      * Initially check if a record exists containing all variables.
      * If one doesn't, try again with a blank Sender and if neccessary
      * try again with a blank message type.
      *
     C     KYINMV        KLIST
     C                   KFLD                    KFNWRK
     C                   KFLD                    KFMTPY
     C                   KFLD                    KFSNDR
      *
     C                   MOVEL     MCNWRK        KFNWRK
     C                   MOVEL     MCMTPY        KFMTPY
     C                   MOVEL     MCSNDR        KFSNDR
      *
     C*****KYINMV        CHAIN     MEINMVL1                           60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVNWRK = :KFNWRK and MVMTPY = :KFMTPY and MVSNDK = :KFSNDR                    MD058081
     C+   and MVRECI = 'D'                                                                  MD058081
     C/END-EXEC                                                                             MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
      *
     C******IN60         IFEQ      '1'                                                      MD058081
     C                   MOVEL     *BLANKS       KFSNDR
     C*****KYINMV        CHAIN     MEINMVL1                           60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVNWRK = :KFNWRK and MVMTPY = :KFMTPY and MVSNDK = :KFSNDR                    MD058081
     C+   and MVRECI = 'D'                                                                  MD058081
     C/END-EXEC                                                                             MD058081
     C                   END
      *
     C******IN60         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
     C                   MOVEL     'ALL'         KFMTPY
     C*****KYINMV        CHAIN     MEINMVL1                           60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVNWRK = :KFNWRK and MVMTPY = :KFMTPY and MVSNDK = :KFSNDR                    MD058081
     C+   and MVRECI = 'D'                                                                  MD058081
     C/END-EXEC                                                                             MD058081
     C                   END
      *
      * If a record is found and an Access Point is defined, check that
      * the passed access point matches.
      *
      * Determine if the Incoming Message may be processed by the value
      * of the Include/Exclude flag.
      *
     C                   SETOFF                                       60                    MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
     C                   SETON                                        60                    MD058081
     C                   ENDIF                                                              MD058081
                                                                                            MD058081
     C     *IN60         IFEQ      '0'
      *
     C                   SELECT                                                             ***
      *
      * Exclude message
      *
     C     MVINEX        WHENEQ    'E'                                                      ***
     C     MVACPT        IFEQ      MCACPT                                                   ***
     C     MCACPT        OREQ      '*FT    '                                                ***
     C     MVACPT        ANDNE     '*ENTRY '                                                ***
     C     MCACPT        OREQ      '*AUTO  '                                                ***
     C     MVACPT        ANDNE     '*ENTRY '                                                ***
     C     MCACPT        OREQ      '*AUTO  '                                                ***
     C     MVACPT        ANDNE     '*FT    '                                                ***
     C                   MOVEL     '1'           *IN60
     C                   END                                                                ***
      *
      * Message access type *ENTRY
      *
     C     MCACPT        WHENEQ    '*ENTRY '                                                ***
      *
     C     MVACPT        IFNE      '*ENTRY '                                                ***
     C     MVACPT        ANDNE     '*FT    '                                                ***
     C     MVACPT        ANDNE     '*AUTO  '                                                ***
      *
     C                   MOVEL     '1'           *IN60
     C                   END
      *
      * Message access type *FT - process in FT
      *
     C     MCACPT        WHENEQ    '*FT    '                                                ***
      *
     C     MVACPT        IFNE      '*FT    '                                                ***
     C     MVACPT        ANDNE     '*AUTO  '                                                ***
      *
     C                   MOVEL     '1'           *IN60
     C                   END
      *
      * Message access type *AUTO - generate FT transaction
      * automatically
      *
     C     MCACPT        WHENEQ    '*AUTO '                                                 ***
      *
     C     MVACPT        IFNE      '*AUTO  '                                                ***
      *
     C                   MOVEL     '1'           *IN60
     C                   END
      *
     C                   ENDSL
      *
     C                   END
      *
      *  /Copy point for Extension file actions
      *
     C/COPY WNCPYSRC,ME1030DACT
      *
      * Set up pay msg flag and return code
      *
     C     *IN60         IFEQ      '0'
     C                   MOVEL     MVPMFG        MCPMFG                         Pay msg ?
     C                   MOVEL     MVBRCA        MCBRCA                         Branch code
     C                   MOVEL     INMC          W0DATA
     C                   MOVEL     'MIN0090'     W0RTN                          Valid
     C                   ELSE
     C                   MOVEL     MVPMFG        MCPMFG                         Pay msg ?
     C                   MOVEL     INMC          W0DATA
     C                   MOVEL     'MIN0091'     W0RTN                          Invalid
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXVERY        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *                                                                                       CSC022
      ** Check if CSC022 is switched *ON.                                                     CSC022
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSC022'      @SARD             6
      *                                                                                       CSC022
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022            1
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT
     C                   IN        SCCMT
     C                   Z-ADD     1             C                 3 0
     C                   MOVEL     *BLANKS       WCMTSK            1
     C                   MOVEA     CMTARR        CMTJOB
     C     CMTNUM        IFGT      0
     C     C             DOWLE     CMTNUM
     C     ##JOB         IFEQ      CMTJOB(C)
     C                   MOVEL     'Y'           WCMTSK
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CSC022
     C                   ENDIF
      *
      *  Define fields
      *
     C     *LIKE         DEFINE    MCNWRK        KFNWRK
     C     *LIKE         DEFINE    MCMTPY        KFMTPY
     C     *LIKE         DEFINE    MCSNDR        KFSNDR
      *
     C     *LIKE         DEFINE    INMC          W0DATA
      *
      * Open Files
      *
     C**********         OPEN      MEINMVL1                                                 MD058081
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
     C/COPY WNCPYSRC,ME1030DCPG
      *
      *  /Copy point for Calculations
      *
     C/EJECT
      *
      *  File and Program Error Processing
      *
     C*COPY*MECPYSRC,SRERRC                                                                 MD058081
     C/COPY MECPYSRC,SRERRCLE                                                               MD058081
     C/EJECT
     C/COPY WNCPYSRC,ME1030DOPG
      *
      *  /Copy point for Outputs
      *
**CTDATA CPY@
(c) Finastra International Limited 2001
