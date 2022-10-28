     H DEBUG ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/**** *  RPGBASEBNC                                                   *                     MD058188
/*STD *  RPGSQLBND                                                    *                     MD058188
/*EXI *  TEXT('Midas GP Global T_GPUTILSR Generation')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPTUTLGEN - Global Utiliser Details Generation               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD058188           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG5361            Date 06Jan05               *
      *                 BUG4521 *CREATE    Date 14Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058188 - Deliverable Data Split for Global files           *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG5361- Change the format of field UTSRCODE                 *
      *  BUG4521- Update file T_GPUTILSR                              *
      *                                                               *
      *****************************************************************

     FGPCUSGL0  IF   E           K DISK    INFSR(*PSSR)
     FT_GRCUSTG IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRCUSTG:T_GRCUSTD0)
     F*GPCTRYL0* IF   E           K DISK    INFSR(*PSSR)                                    MD058188
     FT_GRCTRYG IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRCTRYG:T_GRCTRYD0)
     FGPINDSL0  IF   E           K DISK    INFSR(*PSSR)
     FT_GRINDSG IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRINDSG:T_GRINDSD0)
     FT_LVCONFIGIF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(T_LVCONFIG:TLVCONFIG)
O    FGPUTILL0  O  A E             DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
     D GPCTRY        E DS                  EXTNAME(GPCTRJW0)                                MD058188


      * Read through each record on the global customer file and write to T_GPUTILSR
     C                   READ      GPCUSGD0                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      SET_GPCUST
     C                   WRITE     T_GPUTILSR
     C                   READ      GPCUSGD0                               99
     C                   ENDDO

      * Read through each record on the customer group file and write to T_GPUTILSR
     C                   READ      T_GRCUSTG                              99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      SET_GRCUST
     C                   WRITE     T_GPUTILSR
     C                   READ      T_GRCUSTG                              99
     C                   ENDDO

      * Read through each record on the global country file and write to T_GPUTILSR
     C**********         READ      GPCTRYL0                               99                MD058188
     C/EXEC SQL                                                                             MD058188
     C+ declare ACursor insensitive scroll cursor for                                       MD058188
     C+ select * from GPCTRJW0                                                              MD058188
     C+ order by A4CNCD                                                                     MD058188
     C/END-EXEC                                                                             MD058188
                                                                                            MD058188
     C/EXEC SQL                                                                             MD058188
     C+ open ACursor                                                                        MD058188
     C/END-EXEC                                                                             MD058188
                                                                                            MD058188
     C/EXEC SQL                                                                             MD058188
     C+ fetch next from ACursor into :GPCTRY                                                MD058188
     C/END-EXEC                                                                             MD058188
                                                                                            MD058188
     C******IN99         DOWEQ     *OFF                                                     MD058188
     C     SQLCODE       DOWEQ     0                                                        MD058188
     C                   EXSR      SET_GPCTRY
     C                   WRITE     T_GPUTILSR
     C**********         READ      GPCTRYL0                               99                MD058188
     C/EXEC SQL                                                                             MD058188
     C+ fetch next from ACursor into :GPCTRY                                                MD058188
     C/END-EXEC                                                                             MD058188
     C                   ENDDO

     C/EXEC SQL                                                                             MD058188
     C+ close ACursor                                                                       MD058188
     C/END-EXEC                                                                             MD058188
                                                                                            MD058188
      * Read through each record on the country group file and write to T_GPUTILSR
     C                   READ      T_GRCTRYG                              99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      SET_GRCTRY
     C                   WRITE     T_GPUTILSR
     C                   READ      T_GRCTRYG                              99
     C                   ENDDO

      * Read through each record on the global industry file and write to T_GPUTILSR
     C                   READ      GPINDSL0                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      SET_GPINDS
     C                   WRITE     T_GPUTILSR
     C                   READ      GPINDSL0                               99
     C                   ENDDO

      * Read through each record on the industry group file and write to T_GPUTILSR
     C                   READ      T_GRINDSG                              99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      SET_GRINDS
     C                   WRITE     T_GPUTILSR
     C                   READ      T_GRINDSG                              99
     C                   ENDDO

      * Read through each record on the list vist configuration file and write to T_GPUTILSR
     C                   READ      T_LVCONFIG                             99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      SET_LVCNFG
     C                   WRITE     T_GPUTILSR
     C                   READ      T_LVCONFIG                             99
     C                   ENDDO

     C                   SETON                                        LR
     C                   RETURN

      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a global customer
      ********************************************************************
     C     SET_GPCUST    BEGSR

      * Move GPCUSGPD fields into layout for T_GPUTILSR
      * Type
     C                   Z-ADD     1             UTSRTYPE
      * Code
     C                   EVAL      UTSRCODE = CUSGLOB
      * Name
     C                   EVAL      UTSRNAME = CUSRNM + ' ' + CUSRTN
      * Status
     C                   IF        CUSACTIVE = 'D'
     C                   EVAL      UTSRACTIVE = 'N'
     C                   ELSE
     C                   EVAL      UTSRACTIVE = 'Y'
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a global customer group
      ********************************************************************
     C     SET_GRCUST    BEGSR

      * Move T_GRCUSTG fields into layout for T_GPUTILSR
      * Type
     C                   Z-ADD     2             UTSRTYPE
      * Code
     C                   MOVE      *BLANKS       UTSRCODE                                    BUG5361
     C                   MOVE      CGID          UTSRCODE
     C                   MOVE      UTSRCODE      @Numeric10       10 0                       BUG5361
     C                   EVAL      UTSRCODE = %CHAR(@Numeric10)                              BUG5361
      * Name
     C                   EVAL      UTSRNAME = CGNAME
      * Status
     C                   IF        CGDELETED = 'Y'
     C                   EVAL      UTSRACTIVE = 'N'
     C                   ELSE
     C                   EVAL      UTSRACTIVE = 'Y'
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a global country
      ********************************************************************
     C     SET_GPCTRY    BEGSR

      * Move GPCTRYPD fields into layout for T_GPUTILSR
      * Type
     C                   Z-ADD     3             UTSRTYPE
      * Code
     C                   EVAL      UTSRCODE = A4CNCD
      * Name
     C                   EVAL      UTSRNAME = A4CNNM
      * Status
     C                   IF        A4CHTP = 'D'
     C                   EVAL      UTSRACTIVE = 'N'
     C                   ELSE
     C                   EVAL      UTSRACTIVE = 'Y'
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a global country group
      ********************************************************************
     C     SET_GRCTRY    BEGSR

      * Move T_GRCTRYG fields into layout for T_GPUTILSR
      * Type
     C                   Z-ADD     4             UTSRTYPE
      * Code
     C                   MOVE      *BLANKS       UTSRCODE                                    BUG5361
     C                   MOVE      RGID          UTSRCODE
     C                   MOVE      UTSRCODE      @Numeric10                                  BUG5361
     C                   EVAL      UTSRCODE = %CHAR(@Numeric10)                              BUG5361
      * Name
     C                   EVAL      UTSRNAME = RGNAME
      * Status
     C                   IF        RGDELETED = 'Y'
     C                   EVAL      UTSRACTIVE = 'N'
     C                   ELSE
     C                   EVAL      UTSRACTIVE = 'Y'
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a global industry
      ********************************************************************
     C     SET_GPINDS    BEGSR

      * Move GPINDSPD fields into layout for T_GPUTILSR
      * Type
     C                   Z-ADD     5             UTSRTYPE
      * Code
     C                   EVAL      UTSRCODE = IDGIND
      * Name
     C                   EVAL      UTSRNAME = IDDESC
      * Status
     C                   IF        IDCHTP = 'D'
     C                   EVAL      UTSRACTIVE = 'N'
     C                   ELSE
     C                   EVAL      UTSRACTIVE = 'Y'
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a global industry group
      ********************************************************************
     C     SET_GRINDS    BEGSR

      * Move T_GRINDSG fields into layout for T_GPUTILSR
      * Type
     C                   Z-ADD     6             UTSRTYPE
      * Code
     C                   MOVE      *BLANKS       UTSRCODE                                    BUG5361
     C                   MOVE      IGID          UTSRCODE
     C                   MOVE      UTSRCODE      @Numeric10                                  BUG5361
     C                   EVAL      UTSRCODE = %CHAR(@Numeric10)                              BUG5361
      * Name
     C                   EVAL      UTSRNAME = IGNAME
      * Status
     C                   IF        IGDELETED = 'Y'
     C                   EVAL      UTSRACTIVE = 'N'
     C                   ELSE
     C                   EVAL      UTSRACTIVE = 'Y'
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a list view configuration
      ********************************************************************
     C     SET_LVCNFG    BEGSR

      * Move T_LVCONFIG fields into layout for T_GPUTILSR
      * Type
     C                   Z-ADD     7             UTSRTYPE
      * Code
     C                   MOVE      *BLANKS       UTSRCODE                                    BUG5361
     C                   MOVE      LVID          UTSRCODE
     C                   MOVE      UTSRCODE      @Numeric10                                  BUG5361
     C                   EVAL      UTSRCODE = %CHAR(@Numeric10)                              BUG5361
      * Name
     C                   EVAL      UTSRNAME = LVNAME
      * Status
     C                   EVAL      UTSRACTIVE = 'Y'

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR

O     * Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GPUTILL0
B
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
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
