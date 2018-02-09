     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Setup the dataarea RTSDTA and file')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004134 - Setup the dataarea RTSDTA and file TTRNTM2        *
      *                                                               *
      *  Function:  This program will setup the RTSDTA based from     *
      *  (I/C)      the Teller-ID passed to this program              *
      *                                                               *
      *  Called By: REC4130 - Teller SignOn                           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 TDA035  *CREATE    Date 31Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *  TDA035 - RTS Signon changes for MidasPlus.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    70         No record on TTRNT                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FTTRNT     UF   E           K DISK    INFSR(*PSSR)
      **  Teller controls file
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDTELD        E DS                  EXTNAME(SDTELDPD)
      ** Teller ID Details
 
     D P@USER        E DS                  EXTNAME(MUSERDD)
      ** User detail
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs - long data structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs - short data structure
 
     D                 DS
      **  Data structure to hold key fields of LF/TTRNT
     D  @TTRNT                 1      5
     D  KTBRI                  1      1
     D  KTBID                  2      4
     D  KRCTP                  5      5
 
     D RTSDTA         UDS           256
      **  Job dataarea data structure
 
     D  @TLID                  1      3
     D  @TLBC                  4      6
     D  @SPVI                  7      7
     D  @OVRI                  8     32
     D  @CHTL                 33     39P 0
     D  @NCTL                 40     46P 0
     D  @TLNM                 47     76
     D  @TLMG                 77     80  0
     D  @TLSL                 81     84  0
     D  @TLTO                 85     89  0
     D  @DEPC                 90     92
     D*
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Whether or not *PSSR has been run previously
     D RunBefore       S              1A
 
     D ReturnCode      S              7A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    P#Mode            3
     C                   PARM                    P#TellerID        3
 
      ** Validate Teller-ID
 
     C                   EXSR      SRVTLID
 
      ** Update RTSDTA and files
 
     C                   EXSR      SRUPDAT
 
      **  End the program
 
     C                   MOVE      '1'           *INLR
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRVTLID - Validate Teller ID                                 *
      *                                                               *
      *****************************************************************
     C     SRVTLID       BEGSR
 
      **  Validate Teller-Id - it must exist in SDTELDPD
 
     C                   CALL      'AOTELDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      P#TellerID    @TLID             3
     C     SDTELD        PARM      SDTELD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*INVAL '     ReturnCode
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
     C*****************************************************************
      *                                                               *
      *  SRUPDAT - Update control routine                             *
      *                                                               *
      *****************************************************************
     C     SRUPDAT       BEGSR
 
      ** Move fields to key data structure.
 
     C     KLTRNT        KLIST
     C                   KFLD                    KTBRI
     C                   KFLD                    KTBID
     C                   KFLD                    KRCTP
 
     C                   MOVEL     'T'           KTBRI
     C                   MOVEL     P#TellerID    KTBID
     C                   MOVEL     '1'           KRCTP
 
      **  Check record on file
 
     C     KLTRNT        CHAIN     TTRNTM2F                           70
 
      ** If record exists - update
      ** Update Workstation ID
 
     C     *IN70         IFEQ      '0'
 
     C     P#Mode        IFEQ      'OFF'
     C                   MOVE      *BLANKS       TWID
     C                   UPDATE    TTRNTM2F
     C     *LOCK         IN        RTSDTA
     C                   MOVE      *BLANKS       RTSDTA
     C                   OUT       RTSDTA
     C                   ENDIF
 
     C     P#Mode        IFEQ      'ON '
     C                   MOVEL     PSJobName     TWID
     C                   UPDATE    TTRNTM2F
     C                   EXSR      SRSETDTA
     C                   ENDIF
 
      ** If record does not exist - db error
     C                   ELSE
 
     C                   MOVEL     '*ERROR '     ReturnCode
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA                                          ***************
     C                   Z-ADD     003           DBASE                          ** DB ERR 03 **
     C                   MOVEL     'TTRNTM2'     DBFILE                         ***************
     C                   MOVEL     @TTRNT        DBKEY
     C                   EXSR      *PSSR
 
     C                   END
 
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  ZTSDTA - Update RTSDTA dataarea                              *
      *                                                               *
      *****************************************************************
     C     SRSETDTA      BEGSR
 
     C     *DTAARA       DEFINE                  RTSDTA
 
     C     *LOCK         IN        RTSDTA
     C                   MOVE      FRTLID        @TLID
     C                   MOVE      FRTLBC        @TLBC
     C                   MOVE      FRSPVI        @SPVI
     C                   MOVE      FROVRI        @OVRI
     C                   MOVE      FRCHTL        @CHTL
     C                   MOVE      FRNCTL        @NCTL
     C                   MOVE      FRTLNM        @TLNM
     C                   MOVE      FRTLMG        @TLMG
     C                   MOVE      FRTLSL        @TLSL
     C                   MOVE      FRTLTO        @TLTO
     C                   MOVE      FRDEPC        @DEPC
     C                   OUT       RTSDTA
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
