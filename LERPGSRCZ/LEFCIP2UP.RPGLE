     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility LUX Update')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Lending ILE Module                                   *
      *                                                               *
      *  LEFCIP2UP - LE Facility LUX Update                           *
      *                                                               *
      *  Function: This function will update the LUX extension file.  *
      *                                                               *
      *  Called By: LEFCIPVU  - LE Facility validate and update.      *
      *             LEFCIPRPR - LE Facility repair.                   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 09May06               *
      *                 CER001   *CREATE   Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  89 - Database record lock                                    *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRUPDAT - Update Data Routine                                *
      *  SRSETFLD - Set Fields Routine                                *
      *                                                               *
      *****************************************************************
 
     FLEFCX2PD  UF A E           K DISK
     F                                     RENAME(FCLTYMF6:UPDIDX)
     F                                     COMMIT
      *
      ** Midas ER Facilities details - LUX Extension File
      *
 
     D ValidFCLXEx   E DS                  EXTNAME(LEVFCLX1PD)
      *
      ** ER Facilities details - LUX Extension File
      *
 
     D WFctKey         DS
      *
      ** Data structure of key list used in chaining FCLTY
      *
     D KVCNUM                              LIKE(LVCNUM)
     D KVFACT                              LIKE(LVFACT)
     D KVFCNO                              LIKE(LVFCNO)
 
     D PRTCD           S              7A
     D PACTN           S              1A
 
     D PReturn         S             10A
     D PType           S              1A
 
      *****************************************************************
      *  Main Processing                                              *
      *  Calls: SRUPDAT                                               *
      *****************************************************************
 
     C                   RESET                   UPDIDX
     C                   MOVEL     ValidFCLXEx   WFCTKey
     C                   EXSR      SRUPDAT
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRUPDAT - Update Data Routine                                *
      *  Called by: Main Routine                                      *
      *  Calls: SRSETFLD                                              *
      *****************************************************************
     C     SRUPDAT       BEGSR
     C     FCLXKey       CHAIN     LEFCX2PD                             89
      *
      ** If Interactive mode and record is lock
      *
     C                   IF        PType   = '1' And
     C                             *IN89   = *On
     C                   EVAL      PRTCD   = '*RECLCK'
     C                   RETURN
     C                   ENDIF
      *
      ** If the record exists, the details have been modified by
      ** another user.
      *
     C                   IF        %FOUND  And PACTN = 'I'
     C                   EVAL      PRTCD   = '*RECUPD'
     C                   RETURN
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      PACTN   = 'D'
     C                   DELETE    UPDIDX
     C                   WHEN      PACTN   = 'A'
     C                   EXSR      SRSETFLD
     C                   UPDATE    UPDIDX
     C                   WHEN      PACTN   = 'I'
     C                   EXSR      SRSETFLD
     C                   WRITE     UPDIDX
     C                   ENDSL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSETFLD - Set Field Routine                                 *
      *  Called by: SRUPDAT                                           *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRSETFLD      BEGSR
     C                   EVAL      VNCNUM  = LVCNUM
     C                   EVAL      VNFACT  = LVFACT
     C                   EVAL      VNFCNO  = LVFCNO
     C                   EVAL      VNSUBR  = LVSUBR
     C                   EVAL      VNMOBL  = LVMOBL
     C                   EVAL      VNDGRI  = LVDGRI
     C                   EVAL      VNEXPO  = LVEXPO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Initialization Subroutine                           *
      *****************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PACTN
     C                   PARM                    ValidFCLXEx
 
     C     FCLXKey       KLIST
     C                   KFLD                    KVCNUM
     C                   KFLD                    KVFACT
     C                   KFLD                    KVFCNO
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn
     C                   PARM                    PType
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
