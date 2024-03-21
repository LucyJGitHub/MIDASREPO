     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Update SDCTLXTD trailer file')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000119 - Midas SD Update SDCTLXTD trailer file             *
      *                                                               *
      *  Function:  This program retrieves and updates values         *
      *             hold in the SD trailer files which replaces       *
      *             now redundant SDFCTLPA                            *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD061009           Date 23Jan23               *
      *  Prev Amend No. MD061007 *CREATE   Date 02Feb23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061009 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD061007 - Deliverable Data Split for SDFCTLPA/GPFCTLPA      *
      *                                                               *
      *****************************************************************

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D QSDFC1          DS
     D  AHFLNM                 1     10
     D  AHNORC                11     13P 0
     D  AHNOIN                14     16P 0
     D  AHNOAM                17     19P 0
     D  AHNODL                20     22P 0

      ** Program Variables
     D Mode            S              4A
     D File            S             10A
     D NORC            S              5P 0
     D NOIN            S              5P 0
     D NOAM            S              5P 0
     D NODL            S              5P 0
     D Return          S             10A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** MAIN PROCESSING
     C     *ENTRY        PLIST
     C                   PARM                    Mode
     C                   PARM                    File
     C                   PARM                    NORC
     C                   PARM                    NOIN
     C                   PARM                    NOAM
     C                   PARM                    NODL
     C                   PARM                    Return

     C                   eval      Return = *blanks

      ** if MODE is *RTV
     C                   If        Mode = '*RTV'
      ** zeroise/blank out first parameters
     C                   eval      NORC = 0
     C                   eval      NOIN = 0
     C                   eval      NOAM = 0
     C                   eval      NODL = 0
     C/exec sql
     C+ select AHNORC, AHNOIN, AHNOAM, AHNODL
     C+  into :NORC,   :NOIN,  :NOAM,  :NODL
     C*+***from*SDFCTLPA                                                                    MD061009
     C+   from SDCTLJW0                                                                     MD061009
     C+   where AHFLNM = :File
     C/end-exec

      * if error
     C                   if        SQLCODE <> 0 and SQLCODE <> 100
     C                   eval      Return = '*ERROR'
     C                   dump
     C                   endif

      * if not found
     C                   if        SQLCODE = 100
     C                   eval      Return = '*NRF'
     C                   dump
     C                   endif

     C                   Endif

      ** if MODE is *UPD
     C                   If        Mode = '*UPD'
     C/exec sql
     C*+*update*SDFCTLPA set                                                                MD061009
     C+ update SDCTLXTD set                                                                 MD061009
     C+  AHNORC = :NORC, AHNOIN = :NOIN, AHNOAM = :NOAM, AHNODL = :NODL
     C+   where AHFLNM = :File
     C/end-exec

      * if error
     C                   if        SQLCODE <> 0 and SQLCODE <> 100
     C                   eval      Return = '*ERROR'
     C                   dump
     C                   endif

      * if not found
     C                   if        SQLCODE =100
     C                   eval      Return = '*NRF'
     C                   dump
     C                   endif

     C                   Endif

      ** End program
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
