     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*XBIA*  OVRDBF FILE(TABBRCCVT) TOFILE(SMBRCCVTPD)                    *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Convert branches on file member records')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1091 - Convert branch & settlement fields on file member   *
      *           records                                             *
      *                                                               *
      *  Function: This program will convert all the branch and       *
      *            settlement fields in a file member with the new    *
      *            branch codes as in the file SMBRCCVTPD. It will    *
      *            output suspect fields records to SMSUSFLDPD if     *
      *            the option is 'Y'.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. B18716             Date 12May08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CUP025  *CREATE    Date 21Jan04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  B18716 - Array needs to be increased.                        *
      *  CUP025 - Change branches utility                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *       60         No match record found in READE               *
      *       65         EOF (FILE)                                   *
      *       68         Old branch found in IFRECORD                 *
      *       70         Branch position found in BrPs array          *
      *       72         Record exists in SMSUSFLDL0                  *
      *                                                               *
     F*****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * ReplaceOldBr  - Replace old branch in IFRECORD with new branch*
      * WrtSusFldRec  - Write a record to SMSUSFLDPD                  *
      * *INZSR        - Initialise                                    *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************
     FSMIFILEPD UF   E             DISK    INFSR(*PSSR)
      * Upd : Midsa SM Input file for branches conversion
 
     FSMBRCFLDL1IF   E           K DISK    INFSR(*PSSR)
      * RTV : Midas SM Information about branch fields by file
 
     FSMSUSFLDL0UF A E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      * UPD : Midas SM Suspect fields
 
     FTABBRCCVT IT   F    6        DISK    INFSR(*PSSR)
      * RTV : Midas SM Branches to be converted
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Program data structure
     D/COPY GPCPYSRCG,PSDS
 
      * Pre-runtime array containing branches to be converted from PF/SMBRCCVTPD
     D A_OldBr         S              3    DIM(9999) FROMFILE(TABBRCCVT)
     D                                     PERRCD(1)                            Old branch array
     D A_NewBr         S              3    DIM(9999) ALT(A_OldBr)               New branch array
 
     D IFFLD           DS
     D A_IFFld                 1   6000    DIM(6000)
      * Array holding data of an input record from SMIFILEPD
 
     D*BrPs******      S              5  0 DIM(50)                                            B18716
     D BrPs            S              5  0 DIM(1500)                                          B18716
      * Array holding all possible positions of branch fields on the file
 
     D                 DS
     D W0STRP                  1      5
     D W0STRPN                 1      5  0                                      numeric BFSTRP
 
     D Wrun            S              1                                         *PSSR has been run?
 
     D W               S              5  0                                      BrPs array index
     D Idx             S              5  0                                      A_OldBr array index
     D MaxCvtEntry     S              4  0 INZ(9999)                            Max Nbr of branch
                                                                                entry = DIM(A_OldBr)
     D OBPos           S              5  0                                      Br str. pos in IFFLD
     D SPos            S              5  0                                      Scan start position
 
      *****************************************************************
      * Main processing                                               *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    P0FileName       10            File name
     C                   PARM                    P0FileMbr        10            File member
     C                   PARM                    P0OpSusfld        4            Output Suspect fld
     C                   PARM                    P0Updated         1            member updated
 
      * Get first record from SMIFILEPD
     C                   READ      SMIFILEPD                              65    EOF
     C                   DOW       *IN65 = '0'
 
      * For each record from FILE:
 
      * Initialise arrays and variables
     C                   MOVEL     'N'           Updated           1
     C                   EVAL      Idx      = 1                                 A_OldBrIdx index
 
      * For each entry in array A_OldBr until end of entry in A_OldBr:
 
     C                   DOW       Idx             <= MaxCvtEntry  AND
     C                             A_OldBr(Idx)    <> *BLANK
 
      *   Replace all occurences of the old branch in IFRECORD
      *     with new branch from array A_NewBr
     C                   EXSR      ReplaceOldBr
 
      *   Exit if last entry of A_OldBr reached.
     C                   IF        Idx = MaxCvtEntry
     C                   GOTO      ExitOldBrA
     C                   ELSE
      *   Increment Index of A_OldBr array to get next old branch from A_OldBr array
     C                   EVAL      Idx = Idx + 1
     C                   ENDIF                                                  FI Idx = MaxCvtEntry
 
     C                   ENDDO                                                  ODW Idx<=MaxCvtEntry
                                                                                and A_OldBr(Idx)<>''
UpdReC     ExitOldBrA    TAG
 
      * If update is needed, update the record.
     C                   IF        Updated   = 'Y'
     C                   UPDATE    IFRECORD
     C                   EVAL      P0Updated = 'Y'
     C                   ENDIF
 
      * Read next record from SMIFILEPD
     C                   READ      SMIFILEPD                              65
     C                   ENDDO                                                  ODW *IN65 = '0'
 
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ReplaceOldBr - Check strings in IFRECORD matching old         *
      *                branch in array A_OldBr and replace the        *
      *                strings with new branch from array A_NewBr.    *
      *                                                               *
      * Called by:     Main processing                                *
      *                                                               *
      * Calls:         WrtSusFldRec                                   *
      *                                                               *
      *****************************************************************
      *
     C     ReplaceOldBr  BEGSR
 
      * Find old branch string in IFRECORD arrau from position 1
     C                   EVAL      SPos = 1                                     Scan from pos 1
     C     A_OldBr(Idx)  SCAN      IFFLD:SPos    OBPos                    68    ON if scan matched
 
     C                   DOW       *IN68 = '1'                                  Old branch found
 
      * If old branch string is found, check the position is as defined
      * in BrPs array.
     C     OBPos         LOOKUP    BrPs                                   70    matched
 
      * If found, replace old branch in NewRcd array with new branch from
      * A_NewBr.
     C                   IF        *IN70 = '1'
     C                   MOVEL     'Y'           Updated
     C                   MOVEA     A_NewBr(Idx)  WrkBrch           3            Work branch
     C                   MOVEA     WrkBrch       A_IFFld(OBPos)
 
     C                   ELSE
 
      * Else (no position found in BrPs array),
      *   output to SMSUSFLDPD if P0OpSusfld is '*YES'
     C                   IF        P0OpSusfld = '*YES'
     C                   EXSR      WrtSusFldRec
     C                   ENDIF
 
     C                   ENDIF                                                  FI *IN70 = '1'
 
      * Set up new scan start position as the position after the previous old br
     C                   EVAL      SPos     = OBPos + 3                         3=branch fld length
     C     A_OldBr(Idx)  SCAN      IFFLD:SPos    OBPos                    68    ON if scan matched
 
     C                   ENDDO                                                  ODW *IN68 = '1'
 
     C     ReplaceOldBrE ENDSR
      *
      *****************************************************************
      *                                                               *
      * WrtSusFldRec  - Write a record to SMSUSFLDPD if the record    *
      *                 does not already present in file.             *
      *                                                               *
      * Called by:      ReplaceOldBr                                  *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     WrtSusFldRec  BEGSR
 
      * Set up key list to access SMSUSFLDL0
     C                   EVAL      SFOLDB   = A_OldBr(Idx)
     C                   EVAL      SFSTRP   = OBPos
 
      * Check if the record exists in file SMSUSFLDL0
     C     SusFldKey     CHAIN     SMSUSFLDL0                         72        On if rec not found
 
      * If not found, output a record to file.
     C                   IF        *IN72 = '1'
     C                   WRITE     SMSUSFLDD0
     C                   ENDIF
 
     C     WrtSusFldRecE ENDSR
      *
      *****************************************************************
      *                                                               *
      * *INZSR -   Program Initialisation routine                     *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
      * Key to access SMSUSFLDPD
     C     SusFldKey     KLIST
     C                   KFLD                    P0FileName                     File name
     C                   KFLD                    P0FileMbr                      File member
     C                   KFLD                    SFOLDB                         Old branch
     C                   KFLD                    SFSTRP                         Branch string st pos
 
      * Fill Branch fields position array (BrPs) from file LF/SMBRCFLDL1
     C                   Z-ADD     0             W
 
     C     P0FileName    SETLL     SMBRCFLDL1
     C     P0FileName    READE     SMBRCFLDL1                             60
     C     *IN60         DOWEQ     *OFF
     C                   ADD       1             W
     C                   EVAL      W0STRP  = BFSTRP
     C                   EVAL      BrPs(W) = W0STRPN                            Br string str pos
     C     P0FileName    READE     SMBRCFLDL1                             60
     C                   ENDDO                                                  ODW *in60 = *OFF
 
      * If the output suspect field is 'Y', open file SMSUSFLDPD
     C                   IF        P0OpSusfld = '*YES'
     C                   OPEN      SMSUSFLDL0
     C                   EVAL      SFFILE     = P0FileName
     C                   EVAL      SFFMBR     = P0FileMbr
     C                   ENDIF
 
     C     INZSRE        ENDSR
      *
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANK
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
