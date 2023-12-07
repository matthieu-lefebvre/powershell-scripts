Initialize-Disk -Number 2 -PartitionStyle MBR -PassThru |

New-Partition -DiskNumber 2 -DriveLetter T -UseMaximumSize |

Format-Volume -FileSystem NTFS -NewFileSystemLabel "TTS"
