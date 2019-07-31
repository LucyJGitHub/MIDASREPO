     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Write to Cash Management Exceptions file')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  REWRTCMX - Write to Cash Management Exceptions File          *
      *                                                               *
      *  Function:  This program is given exception details and       *
      *             writes to file RECMEXPD.                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRECMEXPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Write a record
 
     C                   EXSR      WRT_RECORD
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Write a record
      ********************************************************************
     C     WRT_RECORD    BEGSR
 
      * Hierarchy ID
     C                   MOVEL     I_HIER        EXHIER
      * Hierarchy Shortname
     C                   MOVEL     I_HISN        EXHISN
      * Link ID
     C                   MOVEL     I_LINK        EXLINK
      * Exception
      * Reason
     C                   MOVEL     I_EXCP        EXEXCP
     C                   MOVEL     I_REAS        EXREAS
      * Zero Balancing/Sweeping Entry
      * Original Entry
     C                   MOVEL     I_ZSEN        EXZSEN
     C                   MOVEL     I_OREN        EXOREN
      * Mode
     C                   MOVEL     I_MODE        EXMODE
      * Time
     C     I_TIME        IFNE      *BLANK
     C                   MOVEL     I_TIME        EXTIME
     C                   ELSE
     C                   Z-ADD     *ZERO         EXTIME
     C                   ENDIF
 
     C                   WRITE     RECMEXD0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
 
      * INPUTS
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Exception
      * Reason
     C                   PARM                    I_EXCP           60
     C                   PARM                    I_REAS           60
      * Zero Balancing/Sweeping Entry
      * Original Entry
     C                   PARM                    I_ZSEN           60
     C                   PARM                    I_OREN          330
      * Mode
      * Time
     C                   PARM                    I_MODE            3
     C                   PARM                    I_TIME            6
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
