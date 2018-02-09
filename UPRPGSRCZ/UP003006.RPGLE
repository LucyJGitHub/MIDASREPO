     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Update global SD cross reference tables')
      *****************************************************************
      *                                                               *
      *  Midas Plus - Bridge                                          *
      *                                                               *
      *  UP003006 - Control program for cross reference file rebuild  *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSC033  *CREATE    Date 01May07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC033 - Include global libraries in backups                 *
      *                                                               *
      *****************************************************************
      *
     D  XREFFILES      S             10    DIM(6) PERRCD(1) CTDATA
     D  ZONEKEYS       S             10    DIM(6) PERRCD(1) CTDATA
     D  TABLENAME      S             10
     D  INZONE         S             10
     D  RSTGMLIB       S             10
     D  ZONEKEY        S             10
     D  X              S              3P 0
      *
      *  While end of cross-reference file table has not been reached,
      *
     C                   EVAL      X = 1
     C     X             DOWLE     6
      *
      *  get the name of a cross-reference file.
      *
     C                   EVAL      TABLENAME = XREFFILES(X)
      *
      *  determine the name of the zone field on the file,
      *
     C                   EVAL      ZONEKEY = ZONEKEYS(X)
      *
      *  and call program UP003004 to update the file.
      *
     C                   CALL      'UP003004'
     C                   PARM                    INZONE
     C                   PARM                    RSTGMLIB
     C                   PARM                    TABLENAME
     C                   PARM                    ZONEKEY
      *
      *  Increment the index.
      *
     C                   EVAL      X = (X + 1)
      *
     C                   ENDDO
      *
     C     McENDER       TAG
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      /SPACE 5
      ********************************************************************
      * *INZSR - Initial Processing
      ********************************************************************
     C     *INZSR        BEGSR
      *
      *  Program parameter list.
      *
     C     *ENTRY        PLIST
     C                   PARM                    INZONE           10
     C                   PARM                    RSTGMLIB         10
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *BLANKS
 
     C                   MOVE      'Y'           RunBefore         1
 
     C                   DUMP
     C                   ENDIF
 
     C                   SETON                                        LRU7U8
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
** XREFFILES
GPACODXPD
GPACOFXPD
GPINDSXPD
GPINSTXPD
GPPRFCXPD
GPPRODXPD
** ZONEKEYS
ACZONE
ACZONE
IDZONE
INZONE
PCZONE
PDZONE
