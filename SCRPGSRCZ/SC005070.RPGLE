     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Midas clustering - populate obj spec file')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC005070 - Populate the Object Specifier File for Clustering *
      *                                                               *
      *  Function:  This program draws on system information to       *
      *  populate the object specifier file for clustering (SCOBSPPD).*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Prev Amend No. CSC013  *CREATE    Date 08Nov01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC013 - Midas Clustering                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file for PF/SCNJRNPD                     *
      *    77         Error indicator for QXXRTVDA                    *
      *    98         Date Format                                     *
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
      * Add_DMLIB - Write a record for xxDMLIB.                       *
      * Add_DPLIB - Write a record for xxDPLIB.                       *
      * Add_DVLIB - Write a record for xxDVLIB.                       *
      * Add_DTALIB - Write a record for xxDTALIB.                     *
      * Add_JNSTAT - Write a record for JNSTAT.                       *
      * Rmv_NJRN - Write 'omit' records for files not journaled.      *
      * Rmv_QCST - Write 'omit' records for CRG data areas.           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSCOBSPPD  O    E             DISK
     FSCNJRNPD  IF   E             DISK
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
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
     D dta_off         S              9B 0
     D dta_len         S              9B 0
     D data_area       S             20
     D Sys_ID          S              2
     D lang            S              3
     D ccsid           S              5  0
     D coun            S              2
     D PATH            S           4998
     D NJLIB           S             10
      *
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
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   END
      *
      *  Execute subroutine 'Add_DMLIB' to write an entry for 'xxDMLIB'.
      *
     C                   exsr      Add_DMLIB
      *
      *  Execute subroutine 'Add_DPLIB' to write an entry for 'xxDPLIB'.
      *
     C                   exsr      Add_DPLIB
      *
      *  Execute subroutine 'Add_DVLIB' to write an entry for 'xxDVLIB'.
      *
     C                   exsr      Add_DVLIB
      *
      *  Execute subroutine 'Add_DTALIB' to write an entry for 'xxDTALIB'.
      *
     C                   exsr      Add_DTALIB
      *
      *  Execute subroutine 'Add_JNSTAT' to write an entry for JNSTAT.
      *
     C                   exsr      Add_JNSTAT
      *
      *  Execute subroutine 'Rmv_NJRN' to write 'omit' entries for files
      *  that are not journaled.  These are listed in PF/SCNRJNPD.
      *
     C                   exsr      Rmv_NJRN
      *
      *  Execute subroutine 'Rmv_QCST' to write 'omit' entries for the
      *  2 Cluster Resource Group data areas, QCSTHAAPPI and QCSTHAAPPO.
      *
     C                   exsr      Rmv_QCST
      *
      *  Close files and return.
      *
     C                   move      *ON           *INLR
     C                   return
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Add_DMLIB - Write a record for xxDMLIB                        *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     Add_DMLIB     begsr
      *
      *  Set entry type to binary zero.
      *
     C                   eval      QCSTETYP = 0
      *
      *  Set object type to '*ALL'.
      *
     C                   eval      QCSTOTYP = '*ALL      '
      *
      *  Set object attribute to '*ALL'.
      *
     C                   eval      QCSTEOAT = '*ALL      '
      *
      *  Set include/exclude indicator to include (binary zero).
      *
     C                   eval      QCSTINEX = 0
      *
      *  Set reserved field to blanks.
      *
     C                   eval      QCSTRSRV = '              '
      *
      *  Set the CCSID to the value obtained in program initilisation.
      *
     C                   eval      QCSTCSID = ccsid
      *
      *  Set the country id to the value obtained in program initilisation.
      *
     C                   eval      QCSTCTID = coun
      *
      *  Set the language id to the value obtained in program initilisation.
      *
     C                   eval      QCSTLGID = lang
      *
      *  Set the NLS reserved field to blanks.
      *
     C                   eval      QCSTNLSR = '   '
      *
      *  Set the flag byte to binary 1.
      *
     C                   eval      QCSTFLAG = 1
      *
      *  Set the path name delimiter to '/'.
      *
     C                   eval      QCSTPTHD = '/'
      *
      *  Set the path name and length.
      *
      *  Clear fields.
      *
     C                   clear                   QCSTPTHN
     C                   clear                   PATH
     C                   clear                   xxDMLIB           7
      *
      *  Calculate name of xxDMLIB.
      *
     C                   eval      xxDMLIB = Sys_ID + 'DMLIB'
      *
      *  Calculate full path ('xxDMLIB/*ALL')
      *
     C                   eval      QCSTPTHN = xxDMLIB + '/' + '*ALL'
      *
      *  Evaluate number of bytes in path.
      *
     C                   eval      PATH = xxDMLIB + '/' + '*ALL'
     C                   eval      QCSTPTHL = (%SCAN(' ' : PATH)) - 1
      *
      *  Write record to PF/SCOBSPPD.
      *
     C                   write     SCOBSPD0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Add_DPLIB - Write a record for xxDPLIB                        *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     Add_DPLIB     begsr
      *
      *  Set entry type to binary zero.
      *
     C                   eval      QCSTETYP = 0
      *
      *  Set object type to '*ALL'.
      *
     C                   eval      QCSTOTYP = '*ALL      '
      *
      *  Set object attribute to '*ALL'.
      *
     C                   eval      QCSTEOAT = '*ALL      '
      *
      *  Set include/exclude indicator to include (binary zero).
      *
     C                   eval      QCSTINEX = 0
      *
      *  Set reserved field to blanks.
      *
     C                   eval      QCSTRSRV = '              '
      *
      *  Set the CCSID to the value obtained in program initilisation.
      *
     C                   eval      QCSTCSID = ccsid
      *
      *  Set the country id to the value obtained in program initilisation.
      *
     C                   eval      QCSTCTID = coun
      *
      *  Set the language id to the value obtained in program initilisation.
      *
     C                   eval      QCSTLGID = lang
      *
      *  Set the NLS reserved field to blanks.
      *
     C                   eval      QCSTNLSR = '   '
      *
      *  Set the flag byte to binary 1.
      *
     C                   eval      QCSTFLAG = 1
      *
      *  Set the path name delimiter to '/'.
      *
     C                   eval      QCSTPTHD = '/'
      *
      *  Set the path name and length.
      *
      *  Clear fields.
      *
     C                   clear                   QCSTPTHN
     C                   clear                   PATH
     C                   clear                   xxDPLIB           7
      *
      *  Calculate name of xxDPLIB.
      *
     C                   eval      xxDPLIB = Sys_ID + 'DPLIB'
      *
      *  Calculate full path ('xxDPLIB/*ALL')
      *
     C                   eval      QCSTPTHN = xxDPLIB + '/' + '*ALL'
      *
      *  Evaluate number of bytes in path.
      *
     C                   eval      PATH = xxDPLIB + '/' + '*ALL'
     C                   eval      QCSTPTHL = (%SCAN(' ' : PATH)) - 1
      *
      *  Write record to PF/SCOBSPPD.
      *
     C                   write     SCOBSPD0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Add_DVLIB - Write a record for xxDVLIB                        *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     Add_DVLIB     begsr
      *
      *  Set entry type to binary zero.
      *
     C                   eval      QCSTETYP = 0
      *
      *  Set object type to '*ALL'.
      *
     C                   eval      QCSTOTYP = '*ALL      '
      *
      *  Set object attribute to '*ALL'.
      *
     C                   eval      QCSTEOAT = '*ALL      '
      *
      *  Set include/exclude indicator to include (binary zero).
      *
     C                   eval      QCSTINEX = 0
      *
      *  Set reserved field to blanks.
      *
     C                   eval      QCSTRSRV = '              '
      *
      *  Set the CCSID to the value obtained in program initilisation.
      *
     C                   eval      QCSTCSID = ccsid
      *
      *  Set the country id to the value obtained in program initilisation.
      *
     C                   eval      QCSTCTID = coun
      *
      *  Set the language id to the value obtained in program initilisation.
      *
     C                   eval      QCSTLGID = lang
      *
      *  Set the NLS reserved field to blanks.
      *
     C                   eval      QCSTNLSR = '   '
      *
      *  Set the flag byte to binary 1.
      *
     C                   eval      QCSTFLAG = 1
      *
      *  Set the path name delimiter to '/'.
      *
     C                   eval      QCSTPTHD = '/'
      *
      *  Set the path name and length.
      *
      *  Clear fields.
      *
     C                   clear                   QCSTPTHN
     C                   clear                   PATH
     C                   clear                   xxDVLIB           7
      *
      *  Calculate name of xxDVLIB.
      *
     C                   eval      xxDVLIB = Sys_ID + 'DVLIB'
      *
      *  Calculate full path ('xxDVLIB/*ALL')
      *
     C                   eval      QCSTPTHN = xxDVLIB + '/' + '*ALL'
      *
      *  Evaluate number of bytes in path.
      *
     C                   eval      PATH = xxDVLIB + '/' + '*ALL'
     C                   eval      QCSTPTHL = (%SCAN(' ' : PATH)) - 1
      *
      *  Write record to PF/SCOBSPPD.
      *
     C                   write     SCOBSPD0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Add_DTALIB - Write a record for xxDTALIB                      *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     Add_DTALIB    begsr
      *
      *  Set entry type to binary zero.
      *
     C                   eval      QCSTETYP = 0
      *
      *  Set object type to '*ALL'.
      *
     C                   eval      QCSTOTYP = '*ALL      '
      *
      *  Set object attribute to '*ALL'.
      *
     C                   eval      QCSTEOAT = '*ALL      '
      *
      *  Set include/exclude indicator to include (binary zero).
      *
     C                   eval      QCSTINEX = 0
      *
      *  Set reserved field to blanks.
      *
     C                   eval      QCSTRSRV = '              '
      *
      *  Set the CCSID to the value obtained in program initilisation.
      *
     C                   eval      QCSTCSID = ccsid
      *
      *  Set the country id to the value obtained in program initilisation.
      *
     C                   eval      QCSTCTID = coun
      *
      *  Set the language id to the value obtained in program initilisation.
      *
     C                   eval      QCSTLGID = lang
      *
      *  Set the NLS reserved field to blanks.
      *
     C                   eval      QCSTNLSR = '   '
      *
      *  Set the flag byte to binary 1.
      *
     C                   eval      QCSTFLAG = 1
      *
      *  Set the path name delimiter to '/'.
      *
     C                   eval      QCSTPTHD = '/'
      *
      *  Set the path name and length.
      *
      *  Clear fields.
      *
     C                   clear                   QCSTPTHN
     C                   clear                   PATH
     C                   clear                   xxDTALIB          8
      *
      *  Calculate name of xxDTALIB
      *
     C                   eval      xxDTALIB = Sys_ID + 'DTALIB'
      *
      *  Calculate full path ('xxDTALIB/*ALL')
      *
     C                   eval      QCSTPTHN = xxDTALIB + '/' + '*ALL'
      *
      *  Evaluate number of bytes in path.
      *
     C                   eval      PATH = xxDTALIB + '/' + '*ALL'
     C                   eval      QCSTPTHL = (%SCAN(' ' : PATH)) - 1
      *
      *  Write record to PF/SCOBSPPD.
      *
     C                   write     SCOBSPD0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Add_JNSTAT - Write a record for JNSTAT                        *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     Add_JNSTAT    begsr
      *
      *  Set entry type to binary zero.
      *
     C                   eval      QCSTETYP = 0
      *
      *  Set object type to '*DTAARA'.
      *
     C                   eval      QCSTOTYP = '*DTAARA   '
      *
      *  Set object attribute to '*ALL'.
      *
     C                   eval      QCSTEOAT = '*ALL      '
      *
      *  Set include/exclude indicator to include (binary zero).
      *
     C                   eval      QCSTINEX = 0
      *
      *  Set reserved field to blanks.
      *
     C                   eval      QCSTRSRV = '              '
      *
      *  Set the CCSID to the value obtained in program initilisation.
      *
     C                   eval      QCSTCSID = ccsid
      *
      *  Set the country id to the value obtained in program initilisation.
      *
     C                   eval      QCSTCTID = coun
      *
      *  Set the language id to the value obtained in program initilisation.
      *
     C                   eval      QCSTLGID = lang
      *
      *  Set the NLS reserved field to blanks.
      *
     C                   eval      QCSTNLSR = '   '
      *
      *  Set the flag byte to binary 1.
      *
     C                   eval      QCSTFLAG = 1
      *
      *  Set the path name delimiter to '/'.
      *
     C                   eval      QCSTPTHD = '/'
      *
      *  Set the path name and length.
      *
      *  Clear fields.
      *
     C                   clear                   QCSTPTHN
     C                   clear                   PATH
     C                   clear                   xxJLIB            6
      *
      *  Calculate name of xxJLIB.
      *
     C                   eval      xxJLIB = Sys_ID + 'JLIB'
      *
      *  Calculate full path ('xxJLIB/JNSTAT')
      *
     C                   eval      QCSTPTHN = xxJLIB + '/' + 'JNSTAT'
      *
      *  Evaluate number of bytes in path.
      *
     C                   eval      PATH = xxJLIB + '/' + 'JNSTAT'
     C                   eval      QCSTPTHL = (%SCAN(' ' : PATH)) - 1
      *
      *  Write record to PF/SCOBSPPD.
      *
     C                   write     SCOBSPD0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Rmv_NJRN - Write records for files that are not journaled     *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: SCC005050                                              *
      *                                                               *
      *****************************************************************
      *
     C     Rmv_NJRN      begsr
      *
      *  While end of file has not been reached,
      *
     C     *IN01         doweq     *OFF
      *
      *  Read a record from PF/SCNJRNPD.
      *
     C                   read      SCNJRNPD                               01
      *
      *  If a record was read,
      *
     C     *IN01         ifeq      *OFF
      *
      *  Set entry type to binary zero.
      *
     C                   eval      QCSTETYP = 0
      *
      *  Set object type to '*FILE'.
      *
     C                   eval      QCSTOTYP = '*FILE     '
      *
      *  Set object attribute to '*ALL'.
      *
     C                   eval      QCSTEOAT = '*ALL      '
      *
      *  Set include/exclude indicator to exclude (binary 1).
      *
     C                   eval      QCSTINEX = 1
      *
      *  Set reserved field to blanks.
      *
     C                   eval      QCSTRSRV = '              '
      *
      *  Set the CCSID to the value obtained in program initilisation.
      *
     C                   eval      QCSTCSID = ccsid
      *
      *  Set the country id to the value obtained in program initilisation.
      *
     C                   eval      QCSTCTID = coun
      *
      *  Set the language id to the value obtained in program initilisation.
      *
     C                   eval      QCSTLGID = lang
      *
      *  Set the NLS reserved field to blanks.
      *
     C                   eval      QCSTNLSR = '   '
      *
      *  Set the flag byte to binary 1.
      *
     C                   eval      QCSTFLAG = 1
      *
      *  Set the path name delimiter to '/'.
      *
     C                   eval      QCSTPTHD = '/'
      *
      *  Set the path name and length.
      *
      *  Clear fields.
      *
     C                   clear                   QCSTPTHN
     C                   clear                   PATH
     C                   clear                   FileLIB          10
      *
      *  Determine name of library containing file.
      *
     C                   callb     'SCC005050'
     C                   parm                    NJFILE
     C                   parm                    NJLIB
      *
      *  If file was not found, assume it is a temporary file located in
      *  xxDPLIB.
      *
     C     NJLIB         ifeq      '*NOTFOUND '
      *
     C                   clear                   NJLIB
     C                   movel     xxDPLIB       NJLIB
      *
     C                   endif
      *
      *  Calculate full path.
      *
     C                   eval      QCSTPTHN = %trimr(NJLIB) + '/' +
     C                             %trimr(NJFILE)
      *
      *  Evaluate number of bytes in path.
      *
     C                   eval      PATH = %trimr(NJLIB) + '/' + %trimr(NJFILE)
     C                   eval      QCSTPTHL = (%SCAN(' ' : PATH)) - 1
      *
      *  Write record to PF/SCOBSPPD.
      *
     C                   write     SCOBSPD0
      *
     C                   endif
      *
     C                   enddo
      *
     C                   endsr
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Rmv_QCST - Write records for Cluster Resource Group (CRG)     *
      *            data areas QCSTHAAPPI & QCSTHAAPPO.                *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     Rmv_QCST      begsr
      *
      *  Set entry type to binary zero.
      *
     C                   eval      QCSTETYP = 0
      *
      *  Set object type to '*DTAARA'.
      *
     C                   eval      QCSTOTYP = '*DTAARA   '
      *
      *  Set object attribute to '*ALL'.
      *
     C                   eval      QCSTEOAT = '*ALL      '
      *
      *  Set include/exclude indicator to exclude (binary 1).
      *
     C                   eval      QCSTINEX = 1
      *
      *  Set reserved field to blanks.
      *
     C                   eval      QCSTRSRV = '              '
      *
      *  Set the CCSID to the value obtained in program initilisation.
      *
     C                   eval      QCSTCSID = ccsid
      *
      *  Set the country id to the value obtained in program initilisation.
      *
     C                   eval      QCSTCTID = coun
      *
      *  Set the language id to the value obtained in program initilisation.
      *
     C                   eval      QCSTLGID = lang
      *
      *  Set the NLS reserved field to blanks.
      *
     C                   eval      QCSTNLSR = '   '
      *
      *  Set the flag byte to binary 1.
      *
     C                   eval      QCSTFLAG = 1
      *
      *  Set the path name delimiter to '/'.
      *
     C                   eval      QCSTPTHD = '/'
      *
      *  First, write a record for QCSTHAAPPI.
      *
      *  Set the path name and length.
      *
      *  Clear fields.
      *
     C                   clear                   QCSTPTHN
     C                   clear                   PATH
      *
      *  Calculate full path ('xxDPLIB/QCSTHAAPPI')
      *
     C                   eval      QCSTPTHN = xxDPLIB + '/' + 'QCSTHAAPPI'
      *
      *  Evaluate number of bytes in path.
      *
     C                   eval      PATH = xxDPLIB + '/' + 'QCSTHAAPPI'
     C                   eval      QCSTPTHL = (%SCAN(' ' : PATH)) - 1
      *
      *  Write record to PF/SCOBSPPD.
      *
     C                   write     SCOBSPD0
      *
      *  Secondly, write a record for QCSTHAAPPO.
      *
      *  Set the path name and length.
      *
      *  Clear fields.
      *
     C                   clear                   QCSTPTHN
     C                   clear                   PATH
      *
      *  Calculate full path ('xxDPLIB/QCSTHAAPPO')
      *
     C                   eval      QCSTPTHN = xxDPLIB + '/' + 'QCSTHAAPPO'
      *
      *  Evaluate number of bytes in path.
      *
     C                   eval      PATH = xxDPLIB + '/' + 'QCSTHAAPPO'
     C                   eval      QCSTPTHL = (%SCAN(' ' : PATH)) - 1
      *
      *  Write record to PF/SCOBSPPD.
      *
     C                   write     SCOBSPD0
      *
     C                   endsr
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      *  Determine the 2-character system identifier.
      *
     C                   clear                   Sys_ID
     C                   clear                   data_area
     C                   eval      dta_off = 6
     C                   eval      dta_len = 2
     C                   eval      data_area = 'SDSTAT    ' + '*LIBL     '
     C                   call      'QXXRTVDA'                           77
     C                   parm                    data_area
     C                   parm                    dta_off
     C                   parm                    dta_len
     C                   parm                    Sys_ID
      *
      *  Call program SCC005060 to retrieve required system values.
      *
     C                   callb     'SCC005060'
     C                   parm                    lang              3
     C                   parm                    ccsid             5 0
     C                   parm                    coun              2
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
