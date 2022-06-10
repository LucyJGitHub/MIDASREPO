     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*XBIA*  OVRDBF FILE(SECTYXX) TOFILE(SECTY)   SHARE(*NO)              *
/*XBIB*  OVRDBF FILE(SDSECSL0XX) TOFILE(SDSECSL0) SHARE(*NO)          *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Write to TRAP - SE Security Events Diary')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOWTTSEDE - Write to TRAP - SE Security Events Diary         *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059408  *CREATE  Date 02Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059408 - Portfolio Customer View - Accrued Interest to     *
      *             Date not Calculated using latest IR Diary Event   *
      *                                                               *
      *****************************************************************
      *
     FSECTYXX   IF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(SE_)
     FSDSECSL0XXIF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(SD_)
     FCPOSS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DPOSNDF)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** T R A N S A C T I O N    D E T A I L S
      *
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      *
     D SEDEV         E DS                  EXTNAME(SEDEVD)
     D SECTY         E DS                  EXTNAME(SECTYD) PREFIX(SE_)
     D PRICE         E DS                  EXTNAME(PRICED) PREFIX(PR_)
      *
     D                 DS
     D  PrvTransDtls           1     17
     D  PrvSecurity            1     10
     D  PrvEventDate          11     15
     D  PrvEventType          16     17
      *
     D                 DS
     D  NewTransDtls           1     17
     D  NewSecurity            1     10
     D  NewEventDate          11     15
     D  NewEventType          16     17
      *
     D                 DS
     D  TransDtls              1     17
     D  Security               1     10
     D  EventDate             11     15
     D  EventType             16     17
      *
      ** Overrides
      *
     D ##OV1           S              1    DIM(60) CTDATA PERRCD(60)
     D ##OV2           S              1    DIM(60) CTDATA PERRCD(60)
      *
      ** ENTRY PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
      *
      ** Override/open files
      *
     C     SecuFilesOpen IFNE      'Y'
     C                   CALL      'QCMDEXC'     OV1_Parm
     C                   CALL      'QCMDEXC'     OV2_Parm
     C                   OPEN      SECTYXX
     C                   OPEN      SDSECSL0XX
     C                   MOVEL     'Y'           SecuFilesOpen     1
     C                   ENDIF
      *
      ** On amend, look for change of key fields
      *
     C     I#BIMG        IFNE      *BLANK
     C                   MOVEL     I#BIMG        SEDEV
     C                   MOVEL     SDSN          PrvSecurity
     C                   MOVEL     SDED          PrvEventDate
     C                   MOVEL     SDET          PrvEventType
     C                   ENDIF
      *
     C     I#AIMG        IFNE      *BLANK
     C                   MOVEL     I#AIMG        SEDEV
     C                   MOVEL     SDSN          NewSecurity
     C                   MOVEL     SDED          NewEventDate
     C                   MOVEL     SDET          NewEventType
     C                   ENDIF
      *
     C     SDSN          CHAIN(N)  CPOSNDF                            90
     C     *IN90         DOWEQ     *OFF
      *
      ** Universal Transaction Updates
      *
     C                   EXSR      TRAP_SEDE
      *
     C     SDSN          READE     CPOSNDF                                90
     C                   ENDDO
      *
     C                   RETURN
      *
      /SPACE 5
      ********************************************************************
      * Universal Transaction Updates - Security Events Diary
      ********************************************************************
     C     TRAP_SEDE     BEGSR
      *
      ** Reverse 'Previous' (Before)
      *
     C     I#BIMG        IFNE      *BLANK
     C     I#AIMG        ANDNE     *BLANK
     C     NewTransDtls  ANDNE     PrvTransDtls
     C     I#BIMG        ORNE      *BLANK
     C     I#AIMG        ANDEQ     *BLANK
      *
     C                   MOVEL     I#BIMG        SEDEV
     C                   MOVEL     PrvTransDtls  TransDtls
      *
      * Access security details
      *
     C                   EXSR      ACS_SECURITY
      *
      ** Access customer details
      *
     C     CSCN          CHAIN     @BFREDP                            99
     C  N99SD_BFCLAS     IFEQ      'S'
     C     SD_BFCLAS     OREQ      'D'
      *
      ** SETUP TRANSACTION INDEX RECORD (customer positions)
      ** WRITE TRANSACTION INDEX RECORD
      *
     C                   EXSR      SETUP_TRAPSCPS
     C                   EXSR      WRITE_TRAP
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Apply 'New' (After)
      *
     C     I#AIMG        IFNE      *BLANK
     C                   MOVEL     I#AIMG        SEDEV
     C                   MOVEL     NewTransDtls  TransDtls
      *
      ** Access security details
      *
     C                   EXSR      ACS_SECURITY
      *
      ** Access customer details
      *
     C     CSCN          CHAIN     @BFREDP                            99
     C  N99SD_BFCLAS     IFEQ      'S'
     C     SD_BFCLAS     OREQ      'D'
      *
      ** SETUP TRANSACTION INDEX RECORD (customer positions)
      ** WRITE TRANSACTION INDEX RECORD
      *
     C                   EXSR      SETUP_TRAPSCPS
     C                   EXSR      WRITE_TRAP
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPSCPSBEGSR
      *
     C                   Z-ADD     SDED          EDATE             5 0
      *
     C                   CALLB     'GOSETSCPS'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
      *
      ** INPUTS
      *
     C                   PARM                    CSBA
     C                   PARM                    CSCN
     C                   PARM                    CSSC
     C                   PARM                    EDATE
     C                   PARM                    SECTY
      * OUTPUTS
     C                   PARM                    T_TRAP
      *
     C                   PARM                    PRICE
     C                   PARM                    NomCcyDec         1 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETSCPS'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * WRITE TRANSACTION INDEX RECORD
      ********************************************************************
     C     WRITE_TRAP    BEGSR
      *
      ** Commitment Cycle ID
      *
     C                   Z-ADD     0             T_CCID
      *
     C                   MOVEL     'GLOB'        I#LOC
     C                   MOVEL     'Y'           I#CUSTDEFLT
      *
      /COPY GOCPYSRC,GOWRTTRAP
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Access security details
      ********************************************************************
     C     ACS_SECURITY  BEGSR
      *
      ** Get security details
      *
     C     Security      CHAIN     SECTYDF                            99
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
      *
     C                   Z-ADD     60            MESLEN           15 5
      *
      ** Parameter lists
      *
     C     OV1_Parm      PLIST
     C                   PARM                    ##OV1
     C                   PARM                    MESLEN
     C     OV2_Parm      PLIST
     C                   PARM                    ##OV2
     C                   PARM                    MESLEN
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2022
** ##OV1
OVRDBF FILE(SECTYXX) TOFILE(SECTY)   SHARE(*NO)
** ##OV2
OVRDBF FILE(SDSECSL0XX) TOFILE(SDSECSL0) SHARE(*NO)
