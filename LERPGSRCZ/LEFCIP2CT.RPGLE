     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility LUX Convert')
      *****************************************************************
      *                                                               *
      *  Midas - Lending ILE Module                                   *
      *                                                               *
      *  LEFCIP2CT - LE Facility LUX Convert                          *
      *                                                               *
      *  Function: This function will convert the details of the      *
      *            extension file to screen format.                   *
      *                                                               *
      *  Called By: LEFCIPR - LE Facility details retrieve a record   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 03May06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *  SRSETFLD - Set Fields Routine                                *
      *                                                               *
      *****************************************************************
     D                 DS
     D PReturnCode     S             10A
     D PCustNo         S              6A
     D PFcType         S              3A
     D PFcSeqNo        S              2A
 
     D FCLXExFilFmt  E DS                  EXTNAME(LEFCX2PD)
      *
      ** ER Facility Details Extension File
      *
 
     D FCLXExScnFmt  E DS                  EXTNAME(LEFCRXPD)
      *
      ** Facility input extra data layout file
      *
 
      *****************************************************************
      *  Main Processing                                              *
      *****************************************************************
 
     C                   EXSR      SRINIT
     C                   EXSR      SRSETFLD
     C                   RETURN
 
      *****************************************************************
      *  SRINIT - Initial Procesiing                                  *
      *  Called by: Main Routine                                      *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRINIT        BEGSR
     C                   CLEAR                   FCLXExScnFmt
     C                   ENDSR
 
      *****************************************************************
      *  SRSETFLD - Set Fields Routine                                *
      *  Called by: Main Routine                                      *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRSETFLD      BEGSR
     C                   EVAL      LSUBR   = VNSUBR
     C                   EVAL      LMOBL   = VNMOBL
     C                   MOVE      VNDGRI        LDGRI
     C                   ENDSR
 
      *****************************************************************
      *  *INZSR - Initialization Subroutine                           *
      *****************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    PCustNo
     C                   PARM                    PFcType
     C                   PARM                    PFcSeqNo
     C                   PARM                    FCLXExFilFmt
     C                   PARM                    FCLXExScnFmt
     C                   ENDSR
